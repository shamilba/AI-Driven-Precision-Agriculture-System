"""
models/train_yield_prediction.py

Trains a model to predict crop yield using the real Indian crop-yield dataset.

Input features:
    State, Crop, Season, Area, Rainfall,
    Fertilizer, Pesticide, Temperature

Production is intentionally NOT used because it can cause
target leakage when predicting Yield.

Run:
    python -m models.train_yield_prediction
"""

import os
import sys
import joblib
import pandas as pd

from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.metrics import (
    mean_absolute_error,
    mean_squared_error,
    r2_score
)

sys.path.append(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
)

import config


# ============================================================
# FEATURES
# ============================================================

CATEGORICAL_FEATURES = [
    "State",
    "Crop",
    "Season"
]

NUMERIC_FEATURES = [
    "Area",
    "Rainfall",
    "Fertilizer",
    "Pesticide",
    "Temperature"
]

TARGET = "Yield"


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
                StandardScaler(),
                NUMERIC_FEATURES
            )
        ]
    )


# ============================================================
# LOAD AND PREPARE REAL DATA
# ============================================================

def load_real_yield_data():

    csv_path = config.CROP_YIELD_CSV

    if not os.path.exists(csv_path):
        raise FileNotFoundError(
            f"Yield dataset not found at: {csv_path}"
        )

    df = pd.read_csv(csv_path)

    print(f"Loaded real yield dataset: {csv_path}")
    print(f"Dataset shape: {df.shape}")

    # --------------------------------------------------------
    # Rename real dataset columns to backend feature names
    # --------------------------------------------------------

    df = df.rename(columns={
        "Annual_Rainfall": "Rainfall",
        "Avg_Temperature": "Temperature"
    })

    # --------------------------------------------------------
    # Required columns
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
            f"Dataset is missing expected columns: {missing}"
        )

    # --------------------------------------------------------
    # Production is deliberately excluded.
    #
    # Yield is closely related to Production / Area,
    # so using Production as an input could cause target leakage.
    # --------------------------------------------------------

    return df


# ============================================================
# TRAIN MODEL
# ============================================================

def train():

    os.makedirs(config.MODEL_DIR, exist_ok=True)

    # Load real dataset
    df = load_real_yield_data()

    X = df[
        CATEGORICAL_FEATURES + NUMERIC_FEATURES
    ]

    y = df[TARGET]

    # --------------------------------------------------------
    # Train / Test split
    # --------------------------------------------------------

    X_train, X_test, y_train, y_test = train_test_split(
        X,
        y,
        test_size=0.20,
        random_state=config.RANDOM_STATE
    )

    print(f"Training samples: {len(X_train)}")
    print(f"Testing samples: {len(X_test)}")

    # --------------------------------------------------------
    # Preprocessing
    # --------------------------------------------------------

    preprocessor = build_preprocessor()

    # --------------------------------------------------------
    # Random Forest Regressor
    # --------------------------------------------------------

    model = Pipeline(
        steps=[
            (
                "preprocessor",
                preprocessor
            ),
            (
                "regressor",
                RandomForestRegressor(
                    n_estimators=300,
                    random_state=config.RANDOM_STATE,
                    n_jobs=-1
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
    # Training metrics
    # --------------------------------------------------------

    train_r2 = r2_score(
        y_train,
        y_train_pred
    )

    # --------------------------------------------------------
    # Testing metrics
    # --------------------------------------------------------

    test_mae = mean_absolute_error(
        y_test,
        y_test_pred
    )

    test_rmse = mean_squared_error(
        y_test,
        y_test_pred
    ) ** 0.5

    test_r2 = r2_score(
        y_test,
        y_test_pred
    )

    # --------------------------------------------------------
    # Display results
    # --------------------------------------------------------

    print("\n" + "=" * 50)
    print("YIELD MODEL RESULTS")
    print("=" * 50)

    print(f"Training R² : {train_r2:.4f}")
    print(f"Testing MAE : {test_mae:.4f}")
    print(f"Testing RMSE: {test_rmse:.4f}")
    print(f"Testing R²  : {test_r2:.4f}")

    print("=" * 50)

    # --------------------------------------------------------
    # Save model
    # --------------------------------------------------------

    joblib.dump(
        model,
        config.YIELD_MODEL_PATH
    )

    print(
        f"\nSaved model to:\n"
        f"{config.YIELD_MODEL_PATH}"
    )


# ============================================================
# MAIN
# ============================================================

if __name__ == "__main__":
    train()