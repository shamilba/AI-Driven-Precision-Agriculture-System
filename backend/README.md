# AI-Driven Precision Agriculture — Python Backend

A Flask REST API with three trained ML models, built to sit behind your
Flutter app (`AgricultureApp` in `main.dart`):

| Endpoint                     | Task                                              | Model                    |
|-------------------------------|---------------------------------------------------|---------------------------|
| `POST /api/predict/crop`      | Recommend the best crop from soil + climate data   | RandomForestClassifier    |
| `POST /api/predict/yield`     | Predict expected yield (tons/hectare)              | RandomForestRegressor     |
| `POST /api/predict/fertilizer`| Recommend a fertilizer from soil/crop conditions   | RandomForestClassifier    |
| `GET  /api/health`            | Check API + model status                           | —                          |

## 1. Project layout

```
backend/
├── app.py                     # Flask app + route registration
├── config.py                  # Paths & settings
├── train_all.py                # Trains all 3 models in one go
├── requirements.txt
├── models/
│   ├── train_crop_recommendation.py
│   ├── train_yield_prediction.py
│   └── train_fertilizer_recommendation.py
├── routes/
│   ├── crop_routes.py
│   ├── yield_routes.py
│   └── fertilizer_routes.py
├── utils/
│   ├── data_loader.py         # Loads real CSV or synthetic fallback data
│   ├── model_loader.py        # Cached model loading for inference
│   └── validators.py
├── data/                      # <- put your real CSVs here (see step 2)
├── saved_models/              # <- trained .joblib artifacts land here
└── flutter_integration/
    └── api_service.dart       # Drop-in Dart service for your Flutter app
```

## 2. Use the real published datasets (recommended)

The code ships with a **synthetic data generator** so you can train and run
everything immediately without internet access. For real accuracy, replace
it with the actual public datasets:

1. **Crop recommendation** — Kaggle: *"Crop Recommendation Dataset"*
   (by Atharva Ingle). Save as `data/crop_recommendation.csv` with columns:
   `N,P,K,temperature,humidity,ph,rainfall,label`
2. **Crop yield** — Kaggle: *"Crop Yield Prediction Dataset"* (India, by
   Akshat Gupta / similar). Save as `data/crop_yield.csv` with columns:
   `State,Crop,Season,Area,Rainfall,Fertilizer,Pesticide,Temperature,Yield`
   (rename columns to match if your chosen CSV differs — see
   `models/train_yield_prediction.py`).
3. Fertilizer recommendation — Dataset: fertilizer_recommendation_new.csv.

   This dataset contains 10,000 records and 19 input features covering
   soil properties, nutrient levels, crop information, environmental
   conditions, and previous agricultural information.

   Target column:
   Recommended_Fertilizer

   The model predicts 7 fertilizer classes:
   Compost, DAP, MOP, NPK, SSP, Urea, Zinc Sulphate.

As soon as a matching CSV exists at those paths, `utils/data_loader.py`
automatically uses it instead of the synthetic data — no other code changes
needed.

## 3. Setup

```bash
cd backend
python3 -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

## 4. Train the models

```bash
python train_all.py
```

This prints accuracy / MAE / R² for each model and saves artifacts into
`saved_models/`. Re-run any time you add real data or want to retrain.

## 5. Run the API

```bash
python app.py
```

Server starts at `http://0.0.0.0:5000`. Check it's alive:

```bash
curl http://localhost:5000/api/health
```

### Example requests

```bash
curl -X POST http://localhost:5000/api/predict/crop \
  -H "Content-Type: application/json" \
  -d '{"N":90,"P":42,"K":43,"temperature":20.8,"humidity":82.0,"ph":6.5,"rainfall":202.9}'

curl -X POST http://localhost:5000/api/predict/yield \
  -H "Content-Type: application/json" \
  -d '{"State":"Karnataka","Crop":"Rice","Season":"Kharif","Area":5.2,"Rainfall":1200,"Fertilizer":120,"Pesticide":4.5,"Temperature":27.0}'

curl -X POST http://localhost:5000/api/predict/fertilizer \
  -H "Content-Type: application/json" \
  -d '{"Temperature":26,"Humidity":52,"Moisture":38,"Soil_Type":"Loamy","Crop_Type":"Rice","Nitrogen":37,"Phosphorous":0,"Potassium":0}'
```

## 6. Connect it to your Flutter app

Copy `flutter_integration/api_service.dart` into `lib/services/` in your
Flutter project, add `http: ^1.2.2` to `pubspec.yaml`, and call e.g.:

```dart
final result = await ApiService.recommendCrop(
  n: 90, p: 42, k: 43,
  temperature: 20.8, humidity: 82.0, ph: 6.5, rainfall: 202.9,
);
print(result['recommended_crop']);
```

Remember to set `ApiService.baseUrl`:
- Android emulator → `http://10.0.2.2:5000`
- iOS simulator / desktop → `http://localhost:5000`
- Physical device → your machine's LAN IP, e.g. `http://192.168.1.20:5000`
- Production → your deployed backend URL (see below)

## 7. Deploying for production

Don't use Flask's dev server in production. Use gunicorn:

```bash
gunicorn -w 4 -b 0.0.0.0:5000 app:app
```

Host it on any Python-friendly platform (Render, Railway, a small VPS,
AWS/GCP/Azure App Service, etc.), then point `ApiService.baseUrl` at that
public URL. Also tighten CORS in `app.py` (`origins="*"` → your app's actual
domain) before shipping.

## 8. Extending

- Swap `RandomForestClassifier`/`Regressor` for `XGBoost`/`LightGBM` in the
  `models/train_*.py` files if you want higher accuracy — the rest of the
  pipeline (routes, loader, Flutter service) doesn't need to change.
- Add a disease-detection endpoint by adding a CNN (e.g. TensorFlow/Keras)
  under `models/`, a route under `routes/`, and registering the blueprint
  in `app.py` the same way the other three are wired up.
# AI Model Documentation

## 1. Crop Recommendation Model

### Dataset
- Dataset: crop_recommendation.csv
- Rows: 2,200
- Input features: 7
- Target: label
- Features:
  - Nitrogen (N)
  - Phosphorus (P)
  - Potassium (K)
  - Temperature
  - Humidity
  - pH
  - Rainfall

### Algorithm
Random Forest Classifier with 300 decision trees.

### Model Performance
- Training Accuracy: 99.86%
- Testing Accuracy: 99.32%

### Algorithm Comparison
- Decision Tree Test Accuracy: 97.95%
- Random Forest Test Accuracy: 99.32%

Random Forest was retained because it achieved higher test accuracy on the same train/test split.

### Important Features

| Feature | Importance |
|---|---:|
| Rainfall | 22.15% |
| Humidity | 21.19% |
| Potassium | 17.92% |
| Phosphorus | 15.37% |
| Nitrogen | 10.39% |
| Temperature | 7.58% |
| pH | 5.39% |

### Why Random Forest?
- Uses multiple decision trees.
- Captures non-linear relationships.
- Works well with multiple numerical features.
- Provides feature-importance information.
- Performed better than the Decision Tree in our comparison.

### Project Explanation
The Crop Recommendation module uses a Random Forest Classifier trained on soil and environmental parameters such as N, P, K, temperature, humidity, pH, and rainfall to recommend a suitable crop.

## 2. Yield Prediction Model

### Dataset

- Dataset: crop_yield.csv
- Rows: 19,689
- Target: Yield
- Input features:
  - State
  - Crop
  - Season
  - Area
  - Rainfall
  - Fertilizer
  - Pesticide
  - Temperature

### Data Preparation

The original dataset contains:
- Annual_Rainfall → used as Rainfall
- Avg_Temperature → used as Temperature

The `Production` column was excluded from the model inputs because it can cause target leakage when predicting Yield.

### Algorithm

Random Forest Regressor with 300 decision trees.

### Model Performance

- Training R²: 99.31%
- Testing MAE: 10.9312
- Testing RMSE: 177.0489
- Testing R²: 96.09%

### Important Features

The Random Forest model identified the following important transformed features:

| Feature | Importance |
|---|---:|
| Crop_Coconut | 84.11% |
| Temperature | 5.51% |
| State_West Bengal | 2.46% |
| Pesticide | 1.88% |
| Area | 1.82% |
| Fertilizer | 1.65% |
| Rainfall | 1.05% |

These feature-importance values indicate the features that contributed most to the model's predictions. They should not be interpreted as causal relationships.

### Why Random Forest?

- Combines predictions from multiple decision trees.
- Can model non-linear relationships.
- Handles both numerical and categorical agricultural information through preprocessing.
- Provides feature-importance information.
- Produces strong predictive performance on the test dataset.

### Project Explanation

The Yield Prediction module uses a Random Forest Regressor to estimate crop yield using information such as crop type, state, season, cultivated area, rainfall, fertilizer usage, pesticide usage, and temperature.

## 3. Fertilizer Recommendation Model

### Dataset

- Dataset: fertilizer_recommendation_new.csv
- Rows: 10,000
- Target: Recommended_Fertilizer
- Number of fertilizer classes: 7

The fertilizer classes are:
- Compost
- DAP
- MOP
- NPK
- SSP
- Urea
- Zinc Sulphate

### Input Features

#### Categorical Features
- Soil Type
- Crop Type
- Crop Growth Stage
- Season
- Irrigation Type
- Previous Crop
- Region

#### Numerical Features
- Soil pH
- Soil Moisture
- Organic Carbon
- Electrical Conductivity
- Nitrogen Level
- Phosphorus Level
- Potassium Level
- Temperature
- Humidity
- Rainfall
- Fertilizer Used Last Season
- Yield Last Season

### Algorithm

Random Forest Classifier with 300 decision trees.

### Model Performance

- Training Accuracy: 100.00%
- Testing Accuracy: 87.25%
- Testing Balanced Accuracy: 72.51%

The model was evaluated using both normal accuracy and balanced accuracy because the fertilizer classes are not equally represented in the dataset.

### Classification Performance

| Fertilizer | Precision | Recall | F1-Score |
|---|---:|---:|---:|
| Compost | 0.77 | 0.82 | 0.79 |
| DAP | 0.96 | 0.92 | 0.94 |
| MOP | 0.84 | 0.86 | 0.85 |
| NPK | 0.90 | 0.70 | 0.78 |
| SSP | 0.00 | 0.00 | 0.00 |
| Urea | 0.94 | 0.95 | 0.94 |
| Zinc Sulphate | 0.60 | 0.83 | 0.70 |

### Why Random Forest?

- Uses multiple decision trees.
- Can capture non-linear relationships between soil, crop and environmental conditions.
- Handles a mixture of numerical and categorical features after preprocessing.
- Provides a strong baseline for multi-class fertilizer recommendation.
- The model can be further improved, particularly for minority classes.

### Current Limitation

Although the overall testing accuracy is 87.25%, the model does not perform equally well for every fertilizer class. In particular, SSP has very low recall in the current evaluation.

Therefore, further improvement using techniques such as class balancing, oversampling and model comparison is planned.

### Project Explanation

The Fertilizer Recommendation module uses a Random Forest Classifier to recommend a fertilizer based on soil properties, nutrient levels, crop information, environmental conditions and previous agricultural information.