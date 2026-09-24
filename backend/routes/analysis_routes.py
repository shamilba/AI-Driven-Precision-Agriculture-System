from flask import Blueprint, request, jsonify
import pandas as pd

from utils.model_loader import (
    get_crop_model,
    get_crop_label_encoder,
    get_yield_model,
    get_fertilizer_model,
    get_fertilizer_label_encoder
)


analysis_bp = Blueprint(
    "analysis",
    __name__
)


@analysis_bp.route(
    "/api/analyze",
    methods=["POST"]
)
def analyze():

    try:

        data = request.json


        # ------------------
        # Crop Prediction
        # ------------------

        crop_features = [
            data["N"],
            data["P"],
            data["K"],
            data["temperature"],
            data["humidity"],
            data["ph"],
            data["rainfall"]
        ]


        crop_columns = [
            "N",
            "P",
            "K",
            "temperature",
            "humidity",
            "ph",
            "rainfall"
        ]


        crop_model = get_crop_model()
        crop_encoder = get_crop_label_encoder()


        crop_df = pd.DataFrame(
            [crop_features],
            columns=crop_columns
        )


        crop_prediction = crop_model.predict(
            crop_df
        )[0]


        recommended_crop = crop_encoder.inverse_transform(
            [crop_prediction]
        )[0]


        # ------------------
        # Yield Prediction
        # ------------------

        yield_model = get_yield_model()


        yield_data = pd.DataFrame([{

            "State": data["State"],
            "Crop": recommended_crop,
            "Season": data["Season"],
            "Area": data["Area"],
            "Rainfall": data["Rainfall"],
            "Fertilizer": data["Fertilizer"],
            "Pesticide": data["Pesticide"],
            "Temperature": data["Temperature"]

        }])


        predicted_yield = float(
            yield_model.predict(yield_data)[0]
        )


        # ------------------
        # Fertilizer Prediction
        # ------------------

        fertilizer_model = get_fertilizer_model()
        fertilizer_encoder = get_fertilizer_label_encoder()


        fertilizer_data = pd.DataFrame([{

            "Temperature": data["Temperature"],
            "Humidity": data["Humidity"],
            "Moisture": data["Moisture"],
            "Soil_Type": data["Soil_Type"],
            "Crop_Type": recommended_crop,
            "Nitrogen": data["Nitrogen"],
            "Phosphorous": data["Phosphorous"],
            "Potassium": data["Potassium"]

        }])


        fertilizer_prediction = fertilizer_model.predict(
            fertilizer_data
        )[0]


        fertilizer = fertilizer_encoder.inverse_transform(
            [fertilizer_prediction]
        )[0]


        return jsonify({

            "health":"Healthy",

            "disease":"No Disease Found",

            "recommended_crop":recommended_crop,

            "yield_prediction":
                round(predicted_yield,3),

            "recommended_fertilizer":
                fertilizer,

            "irrigation":
                "Water after 2 Days"

        }),200



    except Exception as e:

        return jsonify({

            "error":str(e)

        }),500