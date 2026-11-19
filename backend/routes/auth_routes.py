from flask import Blueprint, request, jsonify

from database.database import db
from models.user_model import User

from werkzeug.security import generate_password_hash, check_password_hash


auth_bp = Blueprint(
    "auth",
    __name__
)


# =========================
# REGISTER USER
# =========================

@auth_bp.route(
    "/api/register",
    methods=["POST"]
)
def register():

    data = request.json


    name = data.get("name")
    email = data.get("email")
    password = data.get("password")
    location = data.get("location")


    if not name or not email or not password:

        return jsonify({
            "error":"Required fields missing"
        }),400



    existing_user = User.query.filter_by(
        email=email
    ).first()


    if existing_user:

        return jsonify({
            "error":"Email already registered"
        }),400



    hashed_password = generate_password_hash(
        password
    )


    user = User(

        name=name,

        email=email,

        password=hashed_password,

        location=location

    )


    db.session.add(user)

    db.session.commit()



    return jsonify({

        "message":
        "User registered successfully"

    }),201





# =========================
# LOGIN USER
# =========================

@auth_bp.route(
    "/api/login",
    methods=["POST"]
)
def login():


    data = request.json


    email = data.get("email")

    password = data.get("password")



    user = User.query.filter_by(
        email=email
    ).first()



    if not user:

        return jsonify({

            "error":
            "User not found"

        }),404



    if not check_password_hash(
        user.password,
        password
    ):

        return jsonify({

            "error":
            "Invalid password"

        }),401




    return jsonify({

        "message":
        "Login successful",

        "user_id":
        user.id,

        "name":
        user.name

    }),200