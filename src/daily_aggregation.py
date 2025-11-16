import os
from pathlib import Path
from sqlalchemy import create_engine, text

SQL_DIR = Path("sql")

DB_URL = os.getenv(
    "CONNECTED_VEHICLE_DB_URL",
    "postgresql://postgres:<your_password>@localhost:5432/connectedvehicledb",
)

def run_sql_file(conn, path: Path):
    sql_text = path.read_text()
    for stmt in sql_text.split(";"):
        stmt_clean = stmt.strip()
        if not stmt_clean:
            continue
        conn.execute(text(stmt_clean))

def build_daily_agg():
    engine = create_engine(DB_URL)
    agg_file = SQL_DIR / "agg_daily.sql"

    with engine.begin() as conn:
        print(f"Running {agg_file}...")
        run_sql_file(conn, agg_file)

    print("Daily aggregation completed.")


if __name__ == "__main__":
    build_daily_agg()