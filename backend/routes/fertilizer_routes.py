"""
routes/fertilizer_routes.py

POST /api/predict/fertilizer

Uses the new fertilizer recommendation model.

Example body:
{
    "Soil_Type": "Loamy",
    "Soil_pH": 6.5,
    "Soil_Moisture": 45,
    "Organic_Carbon": 1.2,
    "Electrical_Conductivity": 0.8,
    "Nitrogen_Level": 110,
    "Phosphorus_Level": 60,
    "Potassium_Level": 70,
    "Temperature": 28,
    "Humidity": 65,
    "Rainfall": 800,
    "Crop_Type": "Rice",
    "Crop_Growth_Stage": "Vegetative",
    "Season": "Kharif",
    "Irrigation_Type": "Drip",
    "Previous_Crop": "Wheat",
    "Region": "South",
    "Fertilizer_Used_Last_Season": 1,
    "Yield_Last_Season": 3.5
}
"""

from flask import Blueprint, request, jsonify
import pandas as pd

from utils.model_loader import (
    get_fertilizer_model,
    get_fertilizer_label_encoder
)

from utils.validators import (
    require_fields,
    as_float,
    as_str,
    ValidationError
)


fertilizer_bp = Blueprint("fertilizer", __name__)


# ==========================================
# INPUT FIELDS
# ==========================================

CATEGORICAL_FIELDS = [
    "Soil_Type",
    "Crop_Type",
    "Crop_Growth_Stage",
    "Season",
    "Irrigation_Type",
    "Previous_Crop",
    "Region"
]

NUMERIC_FIELDS = [
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


# ==========================================
# FERTILIZER PREDICTION API
# ==========================================

@fertilizer_bp.route("/api/predict/fertilizer", methods=["POST"])
def predict_fertilizer():

    payload = request.get_json(silent=True) or {}

    try:

        # Check all required fields
        require_fields(
            payload,
            CATEGORICAL_FIELDS + NUMERIC_FIELDS
        )

        # Convert categorical fields
        row = {
            field: as_str(payload, field)
            for field in CATEGORICAL_FIELDS
        }

        # Convert numerical fields
        row.update({
            field: as_float(payload, field)
            for field in NUMERIC_FIELDS
        })

    except ValidationError as e:

        return jsonify({
            "error": e.message
        }), 400


    # ==========================================
    # LOAD MODEL
    # ==========================================

    model = get_fertilizer_model()
    encoder = get_fertilizer_label_encoder()


    # ==========================================
    # CREATE INPUT DATAFRAME
    # ==========================================

    X = pd.DataFrame([row])


    # ==========================================
    # MAKE PREDICTION
    # ==========================================

    pred_encoded = model.predict(X)[0]


    # Convert encoded prediction
    # back to fertilizer name
    fertilizer_name = encoder.inverse_transform(
        [pred_encoded]
    )[0]


    # ==========================================
    # RETURN RESPONSE
    # ==========================================

    return jsonify({
        "recommended_fertilizer": fertilizer_name
    }), 200