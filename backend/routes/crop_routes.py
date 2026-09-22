"""
routes/crop_routes.py
POST /api/predict/crop
Body: { "N": 90, "P": 42, "K": 43, "temperature": 20.8,
        "humidity": 82.0, "ph": 6.5, "rainfall": 202.9 }
"""

from flask import Blueprint, request, jsonify
import numpy as np
import pandas as pd

from utils.model_loader import get_crop_model, get_crop_label_encoder
from utils.validators import require_fields, as_float, ValidationError

crop_bp = Blueprint("crop", __name__)

REQUIRED_FIELDS = ["N", "P", "K", "temperature", "humidity", "ph", "rainfall"]


@crop_bp.route("/api/predict/crop", methods=["POST"])
def predict_crop():
    payload = request.get_json(silent=True) or {}
    try:
        require_fields(payload, REQUIRED_FIELDS)
        features = [as_float(payload, f) for f in REQUIRED_FIELDS]
    except ValidationError as e:
        return jsonify({"error": e.message}), 400

    model = get_crop_model()
    encoder = get_crop_label_encoder()

    X = pd.DataFrame([features], columns=REQUIRED_FIELDS)
    pred_encoded = model.predict(X)[0]
    crop_name = encoder.inverse_transform([pred_encoded])[0]

    # Top-3 alternatives with probabilities, useful for showing confidence
    # in the Flutter UI.
    probs = model.predict_proba(X)[0]
    top_idx = np.argsort(probs)[::-1][:3]
    top_predictions = [
        {"crop": encoder.inverse_transform([i])[0], "confidence": round(float(probs[i]), 4)}
        for i in top_idx
    ]

    return jsonify({
        "recommended_crop": crop_name,
        "top_predictions": top_predictions,
    }), 200
