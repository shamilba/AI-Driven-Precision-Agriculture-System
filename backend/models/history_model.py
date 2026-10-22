from database.database import db


class CropHistory(db.Model):

    id = db.Column(
        db.Integer,
        primary_key=True
    )


    user_id = db.Column(
        db.Integer,
        db.ForeignKey("user.id")
    )


    selected_crop = db.Column(
        db.String(50)
    )


    recommended_crop = db.Column(
        db.String(50)
    )


    fertilizer = db.Column(
        db.String(100)
    )


    yield_prediction = db.Column(
        db.Float
    )


    temperature = db.Column(
        db.Float
    )


    humidity = db.Column(
        db.Float
    )


    rainfall = db.Column(
        db.Float
    )


    created_at = db.Column(
        db.DateTime,
        server_default=db.func.now()
    )