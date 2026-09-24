"""
models/train_fertilizer_recommendation.py

Trains a classifier that recommends a fertilizer given Temperature,
Humidity, Moisture, Soil_Type, Crop_Type, Nitrogen, Phosphorous, Potassium.

Run:
    python -m models.train_fertilizer_recommendation
"""

import os
import sys
import joblib
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler, LabelEncoder
from sklearn.metrics import accuracy_score, classification_report

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import config
from utils.data_loader import load_fertilizer_data

CATEGORICAL_FEATURES = ["Soil_Type", "Crop_Type"]
NUMERIC_FEATURES = ["Temperature", "Humidity", "Moisture", "Nitrogen", "Phosphorous", "Potassium"]
TARGET = "Fertilizer_Name"


def build_preprocessor():
    return ColumnTransformer(
        transformers=[
            ("cat", OneHotEncoder(handle_unknown="ignore"), CATEGORICAL_FEATURES),
            ("num", StandardScaler(), NUMERIC_FEATURES),
        ]
    )


def train():
    os.makedirs(config.MODEL_DIR, exist_ok=True)

    df = load_fertilizer_data()
    missing = [c for c in CATEGORICAL_FEATURES + NUMERIC_FEATURES + [TARGET] if c not in df.columns]
    if missing:
        raise ValueError(f"Dataset is missing expected columns: {missing}")

    X = df[CATEGORICAL_FEATURES + NUMERIC_FEATURES]
    y_raw = df[TARGET]

    label_encoder = LabelEncoder()
    y = label_encoder.fit_transform(y_raw)

    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=config.RANDOM_STATE, stratify=y
    )

    preprocessor = build_preprocessor()
    model = Pipeline(steps=[
        ("preprocessor", preprocessor),
        ("classifier", RandomForestClassifier(
            n_estimators=300, random_state=config.RANDOM_STATE, n_jobs=-1
        )),
    ])

    model.fit(X_train, y_train)

    y_pred = model.predict(X_test)
    acc = accuracy_score(y_test, y_pred)
    print(f"Fertilizer recommendation accuracy: {acc:.4f}")
    print(classification_report(y_test, y_pred, target_names=label_encoder.classes_))

    joblib.dump(model, config.FERTILIZER_MODEL_PATH)
    joblib.dump(label_encoder, config.FERTILIZER_LABEL_ENCODER_PATH)
    print(f"Saved model (with embedded preprocessor) to {config.FERTILIZER_MODEL_PATH}")
    print(f"Saved label encoder to {config.FERTILIZER_LABEL_ENCODER_PATH}")


if __name__ == "__main__":
    train()
