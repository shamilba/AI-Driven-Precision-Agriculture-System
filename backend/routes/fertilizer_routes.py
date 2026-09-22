"""
routes/fertilizer_routes.py
POST /api/predict/fertilizer
Body: { "Temperature": 26, "Humidity": 52, "Moisture": 38,
        "Soil_Type": "Loamy", "Crop_Type": "Rice",
        "Nitrogen": 37, "Phosphorous": 0, "Potassium": 0 }
"""

from flask import Blueprint, request, jsonify
import pandas as pd

from utils.model_loader import get_fertilizer_model, get_fertilizer_label_encoder
from utils.validators import require_fields, as_float, as_str, ValidationError

fertilizer_bp = Blueprint("fertilizer", __name__)

CATEGORICAL_FIELDS = ["Soil_Type", "Crop_Type"]
NUMERIC_FIELDS = ["Temperature", "Humidity", "Moisture", "Nitrogen", "Phosphorous", "Potassium"]


@fertilizer_bp.route("/api/predict/fertilizer", methods=["POST"])
def predict_fertilizer():
    payload = request.get_json(silent=True) or {}
    try:
        require_fields(payload, CATEGORICAL_FIELDS + NUMERIC_FIELDS)
        row = {f: as_str(payload, f) for f in CATEGORICAL_FIELDS}
        row.update({f: as_float(payload, f) for f in NUMERIC_FIELDS})
    except ValidationError as e:
        return jsonify({"error": e.message}), 400

    model = get_fertilizer_model()  # Pipeline already includes preprocessing
    encoder = get_fertilizer_label_encoder()

    X = pd.DataFrame([row])
    pred_encoded = model.predict(X)[0]
    fertilizer_name = encoder.inverse_transform([pred_encoded])[0]

    return jsonify({"recommended_fertilizer": fertilizer_name}), 200
