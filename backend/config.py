"""
config.py
Central configuration for paths, model file names, and server settings.
Edit these values instead of hunting through the codebase.
"""

import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# ---- Data ----
DATA_DIR = os.path.join(BASE_DIR, "data")
CROP_RECOMMENDATION_CSV = os.path.join(DATA_DIR, "crop_recommendation.csv")
CROP_YIELD_CSV = os.path.join(DATA_DIR, "crop_yield.csv")
FERTILIZER_CSV = os.path.join(DATA_DIR, "fertilizer_recommendation.csv")

# ---- Saved models ----
MODEL_DIR = os.path.join(BASE_DIR, "saved_models")
CROP_MODEL_PATH = os.path.join(MODEL_DIR, "crop_recommendation_model.joblib")
CROP_LABEL_ENCODER_PATH = os.path.join(MODEL_DIR, "crop_label_encoder.joblib")

YIELD_MODEL_PATH = os.path.join(MODEL_DIR, "yield_prediction_model.joblib")
YIELD_PREPROCESSOR_PATH = os.path.join(MODEL_DIR, "yield_preprocessor.joblib")

FERTILIZER_MODEL_PATH = os.path.join(MODEL_DIR, "fertilizer_model.joblib")
FERTILIZER_PREPROCESSOR_PATH = os.path.join(MODEL_DIR, "fertilizer_preprocessor.joblib")
FERTILIZER_LABEL_ENCODER_PATH = os.path.join(MODEL_DIR, "fertilizer_label_encoder.joblib")

# ---- Server ----
HOST = os.environ.get("BACKEND_HOST", "0.0.0.0")
PORT = int(os.environ.get("BACKEND_PORT", 5000))
DEBUG = os.environ.get("BACKEND_DEBUG", "true").lower() == "true"

# ---- Reproducibility ----
RANDOM_STATE = 42
