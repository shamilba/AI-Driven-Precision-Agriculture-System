"""
models/train_yield_prediction.py

Trains a regressor that predicts crop yield (tons/hectare) given
State, Crop, Season, Area, Rainfall, Fertilizer, Pesticide, Temperature.

Run:
    python -m models.train_yield_prediction
"""

import os
import sys
import joblib
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.metrics import mean_absolute_error, r2_score

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import config
from utils.data_loader import load_crop_yield_data

CATEGORICAL_FEATURES = ["State", "Crop", "Season"]
NUMERIC_FEATURES = ["Area", "Rainfall", "Fertilizer", "Pesticide", "Temperature"]
TARGET = "Yield"


def build_preprocessor():
    return ColumnTransformer(
        transformers=[
            ("cat", OneHotEncoder(handle_unknown="ignore"), CATEGORICAL_FEATURES),
            ("num", StandardScaler(), NUMERIC_FEATURES),
        ]
    )


def train():
    os.makedirs(config.MODEL_DIR, exist_ok=True)

    df = load_crop_yield_data()
    missing = [c for c in CATEGORICAL_FEATURES + NUMERIC_FEATURES + [TARGET] if c not in df.columns]
    if missing:
        raise ValueError(f"Dataset is missing expected columns: {missing}")

    X = df[CATEGORICAL_FEATURES + NUMERIC_FEATURES]
    y = df[TARGET]

    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=config.RANDOM_STATE
    )

    preprocessor = build_preprocessor()
    model = Pipeline(steps=[
        ("preprocessor", preprocessor),
        ("regressor", RandomForestRegressor(
            n_estimators=300, random_state=config.RANDOM_STATE, n_jobs=-1
        )),
    ])

    model.fit(X_train, y_train)

    y_pred = model.predict(X_test)
    mae = mean_absolute_error(y_test, y_pred)
    r2 = r2_score(y_test, y_pred)
    print(f"Yield prediction MAE: {mae:.4f} tons/hectare")
    print(f"Yield prediction R^2: {r2:.4f}")

    # The fitted Pipeline already contains the preprocessor, so a single
    # artifact is enough — no separate preprocessor file needed at inference.
    joblib.dump(model, config.YIELD_MODEL_PATH)
    print(f"Saved model (with embedded preprocessor) to {config.YIELD_MODEL_PATH}")


if __name__ == "__main__":
    train()
