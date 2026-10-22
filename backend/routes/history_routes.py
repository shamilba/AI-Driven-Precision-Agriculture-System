from flask import Blueprint, request, jsonify

from database.database import db
from models.history_model import CropHistory


history_bp = Blueprint(
    "history",
    __name__
)


# ==================================
# SAVE CROP ANALYSIS HISTORY
# ==================================

@history_bp.route(
    "/api/history/save",
    methods=["POST"]
)
def save_history():

    data = request.json


    history = CropHistory(

        user_id=data.get("user_id"),

        selected_crop=data.get("selected_crop"),

        recommended_crop=data.get("recommended_crop"),

        fertilizer=data.get("fertilizer"),

        yield_prediction=data.get("yield_prediction"),

        temperature=data.get("temperature"),

        humidity=data.get("humidity"),

        rainfall=data.get("rainfall")

    )


    db.session.add(history)

    db.session.commit()


    return jsonify({

        "message":
        "Crop history saved successfully"

    }),201





# ==================================
# GET USER HISTORY
# ==================================

@history_bp.route(
    "/api/history/<int:user_id>",
    methods=["GET"]
)
def get_history(user_id):


    records = CropHistory.query.filter_by(
        user_id=user_id
    ).order_by(
        CropHistory.created_at.desc()
    ).all()



    result=[]


    for item in records:

        result.append({

            "selected_crop":
            item.selected_crop,


            "recommended_crop":
            item.recommended_crop,


            "fertilizer":
            item.fertilizer,


            "yield_prediction":
            item.yield_prediction,


            "temperature":
            item.temperature,


            "humidity":
            item.humidity,


            "rainfall":
            item.rainfall,


            "date":
            item.created_at

        })


    return jsonify(result),200

    # =========================
# GET LATEST HISTORY
# =========================

@history_bp.route(
    "/api/history/latest/<int:user_id>",
    methods=["GET"]
)
def latest_history(user_id):


    latest = CropHistory.query.filter_by(
        user_id=user_id
    ).order_by(
        CropHistory.created_at.desc()
    ).first()



    if not latest:

        return jsonify({

            "message":
            "No analysis found"

        }),404



    return jsonify({

        "selected_crop":
        latest.selected_crop,


        "recommended_crop":
        latest.recommended_crop,


        "fertilizer":
        latest.fertilizer,


        "yield_prediction":
        latest.yield_prediction,


        "temperature":
        latest.temperature,


        "humidity":
        latest.humidity,


        "rainfall":
        latest.rainfall,


        "created_at":
        latest.created_at

    }),200