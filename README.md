# cariad-connected-usage-intel

An end-to-end analytics project simulating **connected vehicle usage intelligence** for an automotive software environment (similar to CARIAD / VW Group).

The goal is to build a small **analytics platform** using:

- **PostgreSQL** – Data warehouse backend  
- **SQL** – Dimensional model + aggregations  
- **Python (Pandas + SQLAlchemy)** – ETL pipeline  
- **Power BI** – Interactive BI dashboard for product & usage insights  

---

## 1. Business Problem

Modern connected vehicles continuously send usage events from features like **Navigation, Lock/Unlock, Remote Climate, Charging, Trip History, Voice Assistant**, etc.

Product and BI teams want to know:

- Which features are most/least used?
- How does usage vary by **region, vehicle model, OS, app version**?
- What is the **error rate** per feature / platform?
- How engaged are users (DAU, session duration)?
- How can we monitor **stability of new app versions**?

This project builds a minimal “usage analytics” stack to answer those questions.

---

## 2. Dataset

Source CSV files (in `data/`):

- `connected_vehicle_usage_unclean.csv` – Raw, messy data  
- `connected_vehicle_usage_cleaned.csv` – Cleaned data (output of `clean_data.py` or your notebook)  

Core columns:

- `user_id` – Pseudonymous user identifier  
- `region` – User region / market  
- `vehicle_model` – Model, e.g. “Audi e-tron”, “Porsche Taycan”  
- `feature_name` – Feature used  
- `session_duration_min` – Usage duration in minutes  
- `error_flag` – 0/1 flag for failure  
- `feedback_rating` – User rating (1–5)  
- `app_version` – Mobile app version (e.g. v1.5)  
- `os_type` – iOS / Android  
- `subscription_status` – active / cancelled / trial  
- `feature_used_at` – Timestamp when feature event happened  

The **cleaned** file also contains:

- `date` – Event date  
- `week` – ISO week number  

---

## 3. Data Model (Star Schema)

We use a simple star schema:

- `stg_feature_usage` – Raw staging table
- `dim_user` – User dimension (region, subscription)
- `dim_vehicle` – Vehicle model dimension
- `dim_feature` – Feature dimension
- `fact_feature_usage` – Fact table with events (joins all dims)
- `agg_usage_daily` – Daily aggregate for BI dashboards

---

## 4. Tech Stack & Pipeline

### 4.1 ETL Flow

1. **Clean data**  
   - Use `notebooks/01_data_cleaning.ipynb` or `src/clean_data.py`  
   - Output: `data/connected_vehicle_usage_cleaned.csv`

2. **Load to PostgreSQL staging**  
   - Run: `python src/load_to_postgres.py`  
   - Writes into `stg_feature_usage`

3. **Build dimensions & fact**  
   - Run: `python src/transform_to_dim_fact.py`  
   - Populates `dim_user`, `dim_vehicle`, `dim_feature`, `fact_feature_usage`

4. **Create daily aggregates**  
   - Run: `python src/daily_aggregation.py`  
   - Populates `agg_usage_daily`

5. **Connect Power BI**  
   - Connect to PostgreSQL and build dashboards on top of `agg_usage_daily` + fact tables.

---

## 5. Running the Project

### 5.1 Create database & tables

In PostgreSQL:

```sql
CREATE DATABASE connectedvehicledb;
