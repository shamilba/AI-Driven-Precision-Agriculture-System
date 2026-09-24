"""
routes/yield_routes.py
POST /api/predict/yield
Body: { "State": "Karnataka", "Crop": "Rice", "Season": "Kharif",
        "Area": 5.2, "Rainfall": 1200, "Fertilizer": 120,
        "Pesticide": 4.5, "Temperature": 27.0 }
"""

from flask import Blueprint, request, jsonify
import pandas as pd

from utils.model_loader import get_yield_model
from utils.validators import require_fields, as_float, as_str, ValidationError

yield_bp = Blueprint("yield_bp", __name__)

CATEGORICAL_FIELDS = ["State", "Crop", "Season"]
NUMERIC_FIELDS = ["Area", "Rainfall", "Fertilizer", "Pesticide", "Temperature"]


@yield_bp.route("/api/predict/yield", methods=["POST"])
def predict_yield():
    payload = request.get_json(silent=True) or {}
    try:
        require_fields(payload, CATEGORICAL_FIELDS + NUMERIC_FIELDS)
        row = {f: as_str(payload, f) for f in CATEGORICAL_FIELDS}
        row.update({f: as_float(payload, f) for f in NUMERIC_FIELDS})
    except ValidationError as e:
        return jsonify({"error": e.message}), 400

    model = get_yield_model()  # Pipeline already includes preprocessing
    X = pd.DataFrame([row])
    predicted_yield = float(model.predict(X)[0])

    estimated_production = predicted_yield * row["Area"]

    return jsonify({
        "predicted_yield_tons_per_hectare": round(predicted_yield, 3),
        "estimated_total_production_tons": round(estimated_production, 3),
    }), 200
