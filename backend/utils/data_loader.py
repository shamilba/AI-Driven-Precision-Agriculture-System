"""
utils/data_loader.py

Loads training data for all three models. For each dataset, the loader:
  1. Looks for a real CSV in backend/data/ (recommended — see README for
     the public source to download).
  2. If it isn't there, generates a synthetic dataset whose per-class
     feature ranges are drawn from the published statistics of the
     corresponding public dataset, so the rest of the pipeline (training,
     API, Flutter integration) can be built and tested end-to-end today.

Replace the synthetic fallback with the real CSV before you rely on the
model for real predictions — synthetic data captures the general shape
of the published data but is not a substitute for it.
"""

import os
import numpy as np
import pandas as pd

import sys
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import config

RNG = np.random.default_rng(config.RANDOM_STATE)

# ---------------------------------------------------------------------------
# 1. CROP RECOMMENDATION
#    Feature ranges below approximate the published Kaggle "Crop
#    Recommendation Dataset" (N, P, K, temperature, humidity, ph, rainfall
#    -> label), covering 22 crop classes.
# ---------------------------------------------------------------------------
CROP_FEATURE_RANGES = {
    # crop: (N_min,N_max, P_min,P_max, K_min,K_max, temp_min,temp_max,
    #        humidity_min,humidity_max, ph_min,ph_max, rainfall_min,rainfall_max)
    "rice":        (60, 99, 35, 60, 35, 45, 20, 27, 80, 85, 5.5, 7.0, 180, 300),
    "maize":       (60, 100, 35, 60, 15, 25, 18, 26, 55, 75, 5.5, 7.0, 60, 110),
    "chickpea":    (20, 60, 55, 80, 75, 100, 17, 21, 14, 20, 6.0, 7.5, 65, 95),
    "kidneybeans": (20, 40, 55, 80, 15, 25, 15, 25, 18, 25, 5.5, 6.0, 60, 150),
    "pigeonpeas":  (20, 40, 55, 80, 15, 25, 18, 37, 30, 70, 4.5, 7.0, 90, 200),
    "mothbeans":   (0, 40, 35, 60, 15, 25, 24, 32, 30, 60, 3.5, 9.5, 25, 65),
    "mungbean":    (0, 40, 30, 60, 15, 25, 27, 30, 80, 90, 6.0, 7.0, 40, 65),
    "blackgram":   (20, 60, 55, 80, 15, 25, 25, 35, 60, 70, 6.0, 7.5, 65, 75),
    "lentil":      (0, 30, 55, 80, 15, 25, 18, 30, 60, 70, 6.0, 7.0, 40, 60),
    "pomegranate": (0, 40, 5, 20, 30, 45, 18, 25, 85, 95, 6.0, 7.0, 100, 110),
    "banana":      (80, 120, 70, 95, 45, 55, 25, 30, 75, 85, 5.5, 6.5, 90, 130),
    "mango":       (0, 40, 15, 40, 25, 35, 27, 37, 45, 55, 4.5, 7.0, 65, 100),
    "grapes":      (0, 40, 120, 145, 195, 205, 8, 42, 80, 84, 5.5, 6.5, 65, 75),
    "watermelon":  (80, 120, 5, 20, 45, 55, 24, 27, 80, 90, 6.0, 7.0, 40, 55),
    "muskmelon":   (80, 120, 5, 20, 45, 55, 27, 30, 90, 95, 6.0, 6.9, 20, 30),
    "apple":       (0, 40, 120, 145, 195, 205, 21, 24, 90, 95, 5.5, 6.5, 100, 125),
    "orange":      (0, 40, 5, 30, 5, 15, 10, 35, 90, 95, 6.0, 7.5, 100, 120),
    "papaya":      (30, 70, 45, 70, 45, 55, 23, 44, 90, 95, 6.5, 7.0, 40, 250),
    "coconut":     (0, 40, 5, 30, 25, 35, 25, 30, 90, 100, 5.2, 6.0, 140, 230),
    "cotton":      (100, 140, 35, 60, 15, 25, 22, 27, 75, 85, 5.5, 7.0, 60, 100),
    "jute":        (60, 100, 35, 60, 35, 45, 23, 27, 70, 90, 6.0, 7.5, 150, 200),
    "coffee":      (80, 120, 15, 40, 25, 35, 23, 28, 50, 70, 6.0, 7.5, 150, 200),
}


def _synthetic_crop_recommendation(samples_per_class: int = 100) -> pd.DataFrame:
    rows = []
    for crop, r in CROP_FEATURE_RANGES.items():
        n_lo, n_hi, p_lo, p_hi, k_lo, k_hi, t_lo, t_hi, h_lo, h_hi, ph_lo, ph_hi, rf_lo, rf_hi = r
        for _ in range(samples_per_class):
            rows.append({
                "N": RNG.uniform(n_lo, n_hi),
                "P": RNG.uniform(p_lo, p_hi),
                "K": RNG.uniform(k_lo, k_hi),
                "temperature": RNG.uniform(t_lo, t_hi),
                "humidity": RNG.uniform(h_lo, h_hi),
                "ph": RNG.uniform(ph_lo, ph_hi),
                "rainfall": RNG.uniform(rf_lo, rf_hi),
                "label": crop,
            })
    df = pd.DataFrame(rows)
    return df.sample(frac=1, random_state=config.RANDOM_STATE).reset_index(drop=True)


def load_crop_recommendation_data() -> pd.DataFrame:
    if os.path.exists(config.CROP_RECOMMENDATION_CSV):
        return pd.read_csv(config.CROP_RECOMMENDATION_CSV)
    print(
        "[data_loader] No file at data/crop_recommendation.csv — "
        "using synthetic fallback data. See README to plug in the real dataset."
    )
    return _synthetic_crop_recommendation()


# ---------------------------------------------------------------------------
# 2. CROP YIELD PREDICTION
#    Schema mirrors common public "Crop Yield Prediction" datasets:
#    State, Crop, Season, Area (hectares), Rainfall (mm), Fertilizer (kg),
#    Pesticide (kg), Temperature (C) -> Yield (tons/hectare)
# ---------------------------------------------------------------------------
YIELD_CROPS = ["Rice", "Wheat", "Maize", "Sugarcane", "Cotton", "Soybean", "Groundnut"]
YIELD_SEASONS = ["Kharif", "Rabi", "Whole Year", "Summer", "Winter"]
YIELD_STATES = ["Karnataka", "Punjab", "Maharashtra", "Uttar Pradesh", "Tamil Nadu", "Bihar"]

# Approximate average yield (tons/hectare) per crop, used as the generator's
# base signal so the synthetic target correlates realistically with inputs.
BASE_YIELD_TONS_PER_HA = {
    "Rice": 2.7, "Wheat": 3.2, "Maize": 2.9, "Sugarcane": 70.0,
    "Cotton": 0.5, "Soybean": 1.1, "Groundnut": 1.4,
}


def _synthetic_crop_yield(n_samples: int = 3000) -> pd.DataFrame:
    rows = []
    for _ in range(n_samples):
        crop = RNG.choice(YIELD_CROPS)
        season = RNG.choice(YIELD_SEASONS)
        state = RNG.choice(YIELD_STATES)
        area = RNG.uniform(0.5, 50)          # hectares
        rainfall = RNG.uniform(300, 2500)    # mm/year
        fertilizer = RNG.uniform(20, 250)    # kg/hectare
        pesticide = RNG.uniform(0, 15)       # kg/hectare
        temperature = RNG.uniform(15, 38)    # deg C

        base = BASE_YIELD_TONS_PER_HA[crop]
        # Simple, monotonic-ish synthetic relationship + noise, so a
        # regressor has real signal to learn from.
        yield_value = (
            base
            * (0.6 + 0.006 * fertilizer)
            * (0.7 + 0.0003 * rainfall)
            * (1.0 - abs(temperature - 27) * 0.01)
            * (1.0 - pesticide * 0.005)
        )
        yield_value = max(yield_value + RNG.normal(0, base * 0.08), 0.05)

        rows.append({
            "State": state,
            "Crop": crop,
            "Season": season,
            "Area": round(area, 2),
            "Rainfall": round(rainfall, 1),
            "Fertilizer": round(fertilizer, 1),
            "Pesticide": round(pesticide, 2),
            "Temperature": round(temperature, 1),
            "Yield": round(yield_value, 3),
        })
    return pd.DataFrame(rows)


def load_crop_yield_data() -> pd.DataFrame:
    if os.path.exists(config.CROP_YIELD_CSV):
        return pd.read_csv(config.CROP_YIELD_CSV)
    print(
        "[data_loader] No file at data/crop_yield.csv — "
        "using synthetic fallback data. See README to plug in the real dataset."
    )
    return _synthetic_crop_yield()


# ---------------------------------------------------------------------------
# 3. FERTILIZER RECOMMENDATION
#    Schema mirrors the common public "Fertilizer Prediction" dataset:
#    Temperature, Humidity, Moisture, Soil Type, Crop Type, N, P, K
#    -> Fertilizer Name
# ---------------------------------------------------------------------------
SOIL_TYPES = ["Sandy", "Loamy", "Black", "Red", "Clayey"]
FERT_CROPS = ["Rice", "Wheat", "Maize", "Cotton", "Sugarcane", "Pulses", "Oilseeds"]
FERTILIZERS = ["Urea", "DAP", "14-35-14", "28-28", "17-17-17", "20-20", "10-26-26"]

# Rough target NPK "profile" each fertilizer is best suited to — used only
# to generate a learnable synthetic signal.
FERTILIZER_PROFILE = {
    "Urea":      (90, 10, 10),
    "DAP":       (20, 90, 10),
    "14-35-14":  (14, 35, 14),
    "28-28":     (28, 28, 5),
    "17-17-17":  (17, 17, 17),
    "20-20":     (20, 20, 10),
    "10-26-26":  (10, 26, 26),
}


def _synthetic_fertilizer(n_samples: int = 2500) -> pd.DataFrame:
    rows = []
    fert_names = list(FERTILIZER_PROFILE.keys())
    for _ in range(n_samples):
        fert = RNG.choice(fert_names)
        n_t, p_t, k_t = FERTILIZER_PROFILE[fert]
        n = max(RNG.normal(n_t, 8), 0)
        p = max(RNG.normal(p_t, 8), 0)
        k = max(RNG.normal(k_t, 8), 0)

        rows.append({
            "Temperature": round(RNG.uniform(20, 40), 1),
            "Humidity": round(RNG.uniform(30, 80), 1),
            "Moisture": round(RNG.uniform(20, 65), 1),
            "Soil_Type": RNG.choice(SOIL_TYPES),
            "Crop_Type": RNG.choice(FERT_CROPS),
            "Nitrogen": round(n, 1),
            "Phosphorous": round(p, 1),
            "Potassium": round(k, 1),
            "Fertilizer_Name": fert,
        })
    return pd.DataFrame(rows)


def load_fertilizer_data() -> pd.DataFrame:
    if os.path.exists(config.FERTILIZER_CSV):
        return pd.read_csv(config.FERTILIZER_CSV)
    print(
        "[data_loader] No file at data/fertilizer_recommendation.csv — "
        "using synthetic fallback data. See README to plug in the real dataset."
    )
    return _synthetic_fertilizer()
