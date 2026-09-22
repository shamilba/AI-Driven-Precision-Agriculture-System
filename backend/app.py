"""
app.py
Main Flask application for the AI-Driven Precision Agriculture backend.

Endpoints:
    GET  /api/health              -> service + model status check
    POST /api/predict/crop        -> recommend a crop from soil/climate data
    POST /api/predict/yield       -> predict crop yield
    POST /api/predict/fertilizer  -> recommend a fertilizer

Run (dev):
    python app.py

Run (prod):
    gunicorn -w 4 -b 0.0.0.0:5000 app:app
"""

import os
import sys


sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from flask import Flask, jsonify
from flask_cors import CORS
from routes.analyze_routes import analyze_bp

import config
from routes.crop_routes import crop_bp
from routes.yield_routes import yield_bp
from routes.fertilizer_routes import fertilizer_bp
from routes.analysis_routes import analysis_bp


def create_app():
    app = Flask(__name__)
    # Wide-open CORS so the Flutter app (web/Android/iOS) can call this
    # freely during development. Restrict `origins` before production use.
    CORS(app, resources={r"/api/*": {"origins": "*"}})

    app.register_blueprint(crop_bp)
    app.register_blueprint(yield_bp)
    app.register_blueprint(fertilizer_bp)
    app.register_blueprint(analysis_bp)
    app.register_blueprint(analyze_bp)

    @app.route("/api/health", methods=["GET"])
    def health():
        model_status = {
            "crop_recommendation": os.path.exists(config.CROP_MODEL_PATH),
            "yield_prediction": os.path.exists(config.YIELD_MODEL_PATH),
            "fertilizer_recommendation": os.path.exists(config.FERTILIZER_MODEL_PATH),
        }
        all_ready = all(model_status.values())
        return jsonify({
            "status": "ok",
            "models_trained": model_status,
            "all_models_ready": all_ready,
        }), 200

    @app.errorhandler(404)
    def not_found(_e):
        return jsonify({"error": "Not found"}), 404

    @app.errorhandler(500)
    def server_error(_e):
        return jsonify({"error": "Internal server error"}), 500

    return app


app = create_app()

if __name__ == "__main__":
    app.run(host=config.HOST, port=config.PORT, debug=config.DEBUG)
