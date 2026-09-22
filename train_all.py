"""
train_all.py

Convenience entry point: trains all three models (crop recommendation,
yield prediction, fertilizer recommendation) in one command and saves
them into saved_models/.

Run:
    python train_all.py
"""

from models.train_crop_recommendation import train as train_crop
from models.train_yield_prediction import train as train_yield
from models.train_fertilizer_recommendation import train as train_fertilizer


def main():
    print("=" * 60)
    print("Training crop recommendation model...")
    print("=" * 60)
    train_crop()

    print("\n" + "=" * 60)
    print("Training yield prediction model...")
    print("=" * 60)
    train_yield()

    print("\n" + "=" * 60)
    print("Training fertilizer recommendation model...")
    print("=" * 60)
    train_fertilizer()

    print("\nAll models trained and saved to saved_models/.")


if __name__ == "__main__":
    main()
