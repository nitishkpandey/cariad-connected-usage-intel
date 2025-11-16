import pandas as pd
from pathlib import Path

DATA_DIR = Path("data")
RAW_PATH = DATA_DIR / "connected_vehicle_usage_unclean.csv"
CLEAN_PATH = DATA_DIR / "connected_vehicle_usage_cleaned.csv"


def clean_vehicle_usage():
    df = pd.read_csv(RAW_PATH)

    for col in ["region", "vehicle_model", "feature_name", "app_version", "os_type", "subscription_status"]:
        df[col] = df[col].astype(str).str.strip()

    df["vehicle_model"] = (
        df["vehicle_model"]
        .str.replace(r"\s+", " ", regex=True)
        .str.replace("  ", " ")
        .str.strip()
        .str.lower()
    )

    df["feature_name"] = df["feature_name"].str.replace(r"\s+", " ", regex=True).str.strip()
    df["feedback_rating"] = pd.to_numeric(df["feedback_rating"], errors="coerce")
    df = df.dropna(subset=["user_id", "feature_name", "feature_used_at"])

    df["feature_used_at"] = pd.to_datetime(df["feature_used_at"], utc=True)
    df["date"] = df["feature_used_at"].dt.date
    df["week"] = df["feature_used_at"].dt.isocalendar().week.astype(int)

    DATA_DIR.mkdir(exist_ok=True)
    df.to_csv(CLEAN_PATH, index=False)
    print(f"Saved cleaned data to {CLEAN_PATH} with {len(df)} rows.")

if __name__ == "__main__":
    clean_vehicle_usage()