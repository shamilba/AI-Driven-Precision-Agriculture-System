"""
models/train_fertilizer_recommendation.py

Trains a fertilizer recommendation classifier using the
new 10,000-row precision agriculture dataset.

Run:
    python -m models.train_fertilizer_recommendation
"""

import os
import sys
import joblib
import pandas as pd

from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, LabelEncoder
from sklearn.metrics import (
    accuracy_score,
    classification_report,
    balanced_accuracy_score
)

sys.path.append(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
)

import config


# ============================================================
# DATASET
# ============================================================

FERTILIZER_DATASET = os.path.join(
    config.DATA_DIR,
    "fertilizer_recommendation_new.csv"
)


# ============================================================
# FEATURES
# ============================================================

CATEGORICAL_FEATURES = [
    "Soil_Type",
    "Crop_Type",
    "Crop_Growth_Stage",
    "Season",
    "Irrigation_Type",
    "Previous_Crop",
    "Region"
]

NUMERIC_FEATURES = [
    "Soil_pH",
    "Soil_Moisture",
    "Organic_Carbon",
    "Electrical_Conductivity",
    "Nitrogen_Level",
    "Phosphorus_Level",
    "Potassium_Level",
    "Temperature",
    "Humidity",
    "Rainfall",
    "Fertilizer_Used_Last_Season",
    "Yield_Last_Season"
]

TARGET = "Recommended_Fertilizer"


# ============================================================
# PREPROCESSOR
# ============================================================

def build_preprocessor():

    return ColumnTransformer(
        transformers=[
            (
                "cat",
                OneHotEncoder(handle_unknown="ignore"),
                CATEGORICAL_FEATURES
            ),
            (
                "num",
                "passthrough",
                NUMERIC_FEATURES
            )
        ]
    )


# ============================================================
# LOAD DATASET
# ============================================================

def load_fertilizer_data():

    if not os.path.exists(FERTILIZER_DATASET):
        raise FileNotFoundError(
            f"Fertilizer dataset not found at:\n"
            f"{FERTILIZER_DATASET}"
        )

    df = pd.read_csv(FERTILIZER_DATASET)

    print(f"Loaded fertilizer dataset: {FERTILIZER_DATASET}")
    print(f"Dataset shape: {df.shape}")

    # --------------------------------------------------------
    # Check required columns
    # --------------------------------------------------------

    required_columns = (
        CATEGORICAL_FEATURES
        + NUMERIC_FEATURES
        + [TARGET]
    )

    missing = [
        column
        for column in required_columns
        if column not in df.columns
    ]

    if missing:
        raise ValueError(
            f"Dataset is missing columns: {missing}"
        )

    # --------------------------------------------------------
    # Check missing values
    # --------------------------------------------------------

    missing_values = df[required_columns].isnull().sum().sum()

    print(f"Missing values: {missing_values}")

    # --------------------------------------------------------
    # Check duplicate rows
    # --------------------------------------------------------

    duplicates = df.duplicated().sum()

    print(f"Duplicate rows: {duplicates}")

    return df


# ============================================================
# TRAIN MODEL
# ============================================================

def train():

    os.makedirs(config.MODEL_DIR, exist_ok=True)

    # --------------------------------------------------------
    # Load dataset
    # --------------------------------------------------------

    df = load_fertilizer_data()

    # --------------------------------------------------------
    # Features and target
    # --------------------------------------------------------

    X = df[
        CATEGORICAL_FEATURES + NUMERIC_FEATURES
    ]

    y_raw = df[TARGET]

    # --------------------------------------------------------
    # Encode target labels
    # --------------------------------------------------------

    label_encoder = LabelEncoder()

    y = label_encoder.fit_transform(y_raw)

    print(
        f"\nNumber of fertilizer classes: "
        f"{len(label_encoder.classes_)}"
    )

    print(
        f"Fertilizer classes: "
        f"{list(label_encoder.classes_)}"
    )

    # --------------------------------------------------------
    # Train / Test split
    # --------------------------------------------------------

    X_train, X_test, y_train, y_test = train_test_split(
        X,
        y,
        test_size=0.20,
        random_state=config.RANDOM_STATE,
        stratify=y
    )

    print(f"\nTraining samples: {len(X_train)}")
    print(f"Testing samples: {len(X_test)}")

    # --------------------------------------------------------
    # Preprocessing
    # --------------------------------------------------------

    preprocessor = build_preprocessor()

    # --------------------------------------------------------
    # Random Forest
    # --------------------------------------------------------

    model = Pipeline(
        steps=[
            (
                "preprocessor",
                preprocessor
            ),
            (
                "classifier",
                RandomForestClassifier(
                    n_estimators=300,
                    random_state=config.RANDOM_STATE,
                    n_jobs=-1,
                    class_weight="balanced"
                )
            )
        ]
    )

    # --------------------------------------------------------
    # Train
    # --------------------------------------------------------

    print("\nTraining Random Forest...")

    model.fit(X_train, y_train)

    # --------------------------------------------------------
    # Predictions
    # --------------------------------------------------------

    y_train_pred = model.predict(X_train)
    y_test_pred = model.predict(X_test)

    # --------------------------------------------------------
    # Metrics
    # --------------------------------------------------------

    train_accuracy = accuracy_score(
        y_train,
        y_train_pred
    )

    test_accuracy = accuracy_score(
        y_test,
        y_test_pred
    )

    balanced_accuracy = balanced_accuracy_score(
        y_test,
        y_test_pred
    )

    print("\n" + "=" * 60)
    print("FERTILIZER MODEL RESULTS")
    print("=" * 60)

    print(
        f"Training Accuracy       : "
        f"{train_accuracy:.4f}"
    )

    print(
        f"Testing Accuracy        : "
        f"{test_accuracy:.4f}"
    )

    print(
        f"Testing Balanced Accuracy: "
        f"{balanced_accuracy:.4f}"
    )

    print("\nClassification Report:")

    print(
        classification_report(
            y_test,
            y_test_pred,
            target_names=label_encoder.classes_
        )
    )

    print("=" * 60)

    # --------------------------------------------------------
    # Save model
    # --------------------------------------------------------

    joblib.dump(
        model,
        config.FERTILIZER_MODEL_PATH
    )

    joblib.dump(
        label_encoder,
        config.FERTILIZER_LABEL_ENCODER_PATH
    )

    print(
        f"\nSaved model to:\n"
        f"{config.FERTILIZER_MODEL_PATH}"
    )

    print(
        f"Saved label encoder to:\n"
        f"{config.FERTILIZER_LABEL_ENCODER_PATH}"
    )


# ============================================================
# MAIN
# ============================================================

if __name__ == "__main__":
    train()