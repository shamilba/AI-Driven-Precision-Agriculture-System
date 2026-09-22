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
3. **Fertilizer recommendation** — Kaggle: *"Fertilizer Prediction Dataset"*.
   Save as `data/fertilizer_recommendation.csv` with columns:
   `Temperature,Humidity,Moisture,Soil_Type,Crop_Type,Nitrogen,Phosphorous,Potassium,Fertilizer_Name`

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
