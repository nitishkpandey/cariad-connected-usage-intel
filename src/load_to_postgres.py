import os
import pandas as pd
from sqlalchemy import create_engine, text
from pathlib import Path

DATA_PATH = Path("data") / "connected_vehicle_usage_cleaned.csv"

DB_URL = os.getenv(
    "CONNECTED_VEHICLE_DB_URL",
    "postgresql://postgres:<your_password>@localhost:5432/connectedvehicledb",
)

def load_staging():
    if not DATA_PATH.exists():
        raise FileNotFoundError(f"Cleaned data not found at {DATA_PATH}. Run clean_data.py or your notebook first.")

    df = pd.read_csv(DATA_PATH)

    engine = create_engine(DB_URL)

    with engine.begin() as conn:
    
        print("Truncating stg_feature_usage...")
        conn.execute(text("TRUNCATE TABLE stg_feature_usage;"))
    
        print(f"Loading {len(df)} rows into stg_feature_usage...")
        df.to_sql("stg_feature_usage", conn, index=False, if_exists="append")

    print("Staging load completed.")

if __name__ == "__main__":
    load_staging()