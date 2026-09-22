"""
utils/validators.py
Small helpers to validate and coerce incoming JSON payloads before they
reach a model. Keeps routes/*.py thin and gives the Flutter app clear,
consistent error messages instead of raw stack traces.
"""


class ValidationError(Exception):
    def __init__(self, message):
        super().__init__(message)
        self.message = message


def require_fields(payload: dict, fields: list):
    if not isinstance(payload, dict):
        raise ValidationError("Request body must be a JSON object.")
    missing = [f for f in fields if f not in payload or payload[f] in (None, "")]
    if missing:
        raise ValidationError(f"Missing required field(s): {', '.join(missing)}")


def as_float(payload: dict, field: str) -> float:
    try:
        return float(payload[field])
    except (TypeError, ValueError):
        raise ValidationError(f"Field '{field}' must be a number.")


def as_str(payload: dict, field: str) -> str:
    value = payload[field]
    if not isinstance(value, str) or not value.strip():
        raise ValidationError(f"Field '{field}' must be a non-empty string.")
    return value.strip()
