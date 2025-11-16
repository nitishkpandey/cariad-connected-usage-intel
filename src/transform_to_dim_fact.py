import os
from pathlib import Path
from sqlalchemy import create_engine, text

SQL_DIR = Path("sql")

DB_URL = os.getenv(
    "CONNECTED_VEHICLE_DB_URL",
    "postgresql://postgres:<your_password>@localhost:5432/connectedvehicledb",
)

def run_sql_file(conn, path: Path):
    """Execute a .sql file, splitting on semicolons."""
    sql_text = path.read_text()
    for stmt in sql_text.split(";"):
        stmt_clean = stmt.strip()
        if not stmt_clean:
            continue
        conn.execute(text(stmt_clean))

def load_dims_and_fact():
    engine = create_engine(DB_URL)

    dim_file = SQL_DIR / "dim_load.sql"
    fact_file = SQL_DIR / "fact_load.sql"

    with engine.begin() as conn:
        print(f"Running {dim_file}...")
        run_sql_file(conn, dim_file)
        print(f"Running {fact_file}...")
        run_sql_file(conn, fact_file)

    print("Dimensions and fact table load completed.")

if __name__ == "__main__":
    load_dims_and_fact()