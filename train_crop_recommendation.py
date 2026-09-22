"""
models/train_crop_recommendation.py

Trains a classifier that recommends the best crop to plant given soil and
climate readings: N, P, K, temperature, humidity, ph, rainfall.

Run:
    python -m models.train_crop_recommendation
"""

import os
import sys
import joblib
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics import accuracy_score, classification_report

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import config
from utils.data_loader import load_crop_recommendation_data

FEATURES = ["N", "P", "K", "temperature", "humidity", "ph", "rainfall"]
TARGET = "label"


def train():
    os.makedirs(config.MODEL_DIR, exist_ok=True)

    df = load_crop_recommendation_data()
    missing = [c for c in FEATURES + [TARGET] if c not in df.columns]
    if missing:
        raise ValueError(f"Dataset is missing expected columns: {missing}")

    X = df[FEATURES]
    y_raw = df[TARGET]

    encoder = LabelEncoder()
    y = encoder.fit_transform(y_raw)

    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=config.RANDOM_STATE, stratify=y
    )

    model = RandomForestClassifier(
        n_estimators=300,
        max_depth=None,
        random_state=config.RANDOM_STATE,
        n_jobs=-1,
    )
    model.fit(X_train, y_train)

    y_pred = model.predict(X_test)
    acc = accuracy_score(y_test, y_pred)
    print(f"Crop recommendation model accuracy: {acc:.4f}")
    print(classification_report(y_test, y_pred, target_names=encoder.classes_))

    joblib.dump(model, config.CROP_MODEL_PATH)
    joblib.dump(encoder, config.CROP_LABEL_ENCODER_PATH)
    print(f"Saved model to {config.CROP_MODEL_PATH}")
    print(f"Saved label encoder to {config.CROP_LABEL_ENCODER_PATH}")


if __name__ == "__main__":
    train()
