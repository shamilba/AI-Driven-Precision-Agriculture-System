"""
utils/model_loader.py

Loads trained model artifacts from disk exactly once and caches them in
memory, so each API request doesn't re-read joblib files from disk.
Raises a clear error if a model hasn't been trained yet.
"""

import os
import sys
import joblib

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import config

_cache = {}


def _load(path, friendly_name, train_hint):
    if path in _cache:
        return _cache[path]
    if not os.path.exists(path):
        raise FileNotFoundError(
            f"{friendly_name} not found at {path}. Train it first with:\n"
            f"    {train_hint}"
        )
    obj = joblib.load(path)
    _cache[path] = obj
    return obj


def get_crop_model():
    return _load(config.CROP_MODEL_PATH, "Crop recommendation model",
                 "python -m models.train_crop_recommendation")


def get_crop_label_encoder():
    return _load(config.CROP_LABEL_ENCODER_PATH, "Crop label encoder",
                 "python -m models.train_crop_recommendation")


def get_yield_model():
    return _load(config.YIELD_MODEL_PATH, "Yield prediction model",
                 "python -m models.train_yield_prediction")


def get_fertilizer_model():
    return _load(config.FERTILIZER_MODEL_PATH, "Fertilizer recommendation model",
                 "python -m models.train_fertilizer_recommendation")


def get_fertilizer_label_encoder():
    return _load(config.FERTILIZER_LABEL_ENCODER_PATH, "Fertilizer label encoder",
                 "python -m models.train_fertilizer_recommendation")
