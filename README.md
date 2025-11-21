# vehicle-connected-usage-intel

An end-to-end analytics project simulating **connected vehicle usage intelligence**, similar to how leading automobile group monitors feature usage, app stability, user behavior, and regional performance.  
This project builds a complete analytics stack using **Python, SQL, PostgreSQL, Power BI**, and a dimensional data warehouse.

---

## 1. Project Overview

Modern connected vehicles send millions of usage events — feature interactions, errors, app sessions, and telemetry.  
Product and Data teams need insights such as:

- Which features are heavily used?
- What is the error rate by app version?
- How engaged are users (DAU, session duration)?
- Which regions or vehicle models have the most activity?
- How stable are mobile app releases (iOS/Android)?

This project answers these questions through a mini analytics platform.

---

## 2. System Architecture

The project follows a simple but realistic analytics architecture.  
The diagram (`docs/architecture.png`) summarizes the workflow.

1. **Raw CSV (Landing Zone)**  
   - Source file: `data/connected_vehicle_usage_unclean.csv`  
   - Contains synthetic connected-vehicle usage events with missing values, inconsistent text, and mixed data types.  
   - This is the “raw” layer that mimics data arriving from a data lake or event stream.

2. **Data Cleaning & Enrichment (Jupyter Notebook)**  
   - Notebook: `notebooks/01_data_cleaning.ipynb`  
   - Tasks performed:
     - Handle missing values and outliers  
     - Standardize categorical fields (region, vehicle_model, os_type, feature_name, etc.)  
     - Parse timestamps and extract `date` and `week`  
     - Basic sanity checks / assertions  
   - Output: a curated, analysis-ready CSV  
     - `data/connected_vehicle_usage_cleaned.csv`

3. **Staging Layer in PostgreSQL**  
   - Script: `src/load_to_postgres.py`  
   - Reads the cleaned CSV and loads it into a **staging table**:
     - `stg_feature_usage`  
   - Behavior:
     - Truncates the staging table  
     - Bulk-inserts all rows using SQLAlchemy + psycopg2  
   - This layer mirrors how raw-but-structured data lands in a warehouse before transformations.

4. **Dimensional Model (Dims + Fact)**  
   - Script: `src/transform_to_dim_fact.py`  
   - SQL files:
     - `sql/dim_load.sql` → builds and refreshes:
       - `dim_user`
       - `dim_vehicle`
       - `dim_feature`
     - `sql/fact_load.sql` → builds:
       - `fact_feature_usage` (joins all dimensions with surrogate keys)  
   - This star schema turns the flat event data into a model optimized for analytics and BI.

5. **Aggregation Layer (Daily Metrics)**  
   - Script: `src/daily_aggregation.py`  
   - SQL file:
     - `sql/agg_daily.sql`  
   - Creates and refreshes:
     - `agg_usage_daily`  
   - Metrics captured:
     - Daily events  
     - DAU (Daily Active Users)  
     - Average session duration  
     - Error events and error_rate_pct  
   - This table is the main **serving layer** for BI tools.

6. **Power BI Semantic Layer & Dashboard**  
   - File: `powerbi/dashboard.pbix`  
   - Power BI connects to PostgreSQL and imports:
     - `agg_usage_daily`
     - `dim_user`
     - `dim_vehicle`
     - `dim_feature`
     - `fact_feature_usage`  
   - The report exposes:
     - KPI cards (Total Events, DAU, Error Rate %, Avg Session)  
     - DAU 7-Day Rolling trend line  
     - Feature Usage Share (pie/bar)  
     - Error Rate by App Version  
     - Slicers for region, OS, month, feature  
   - This is what a product, data, or BI team would use day-to-day.

Together, these layers form a mini end-to-end analytics platform:  
**Raw → Cleaned → Staging → Dimensional Warehouse → Aggregates → BI Dashboard.**

---

## 3. Directory Structure

```
cariad-connected-usage-intel/
│
├── data/
│   ├── connected_vehicle_usage_unclean.csv
│   ├── connected_vehicle_usage_cleaned.csv
│
├── notebooks/
│   └── 01_data_cleaning.ipynb
│
├── sql/
│   ├── schema.sql
│   ├── dim_load.sql
│   ├── fact_load.sql
│   └── agg_daily.sql
│
├── src/
│   ├── load_to_postgres.py
│   ├── transform_to_dim_fact.py
│   └── daily_aggregation.py
│
├── powerbi/
│   └── dashboard.pbix
│
├── docs/
│   └── architecture.png
│
└── requirements.txt
│
│
└── README.md
```

---

## 4. Data Cleaning (Jupyter Notebook)

Use the notebook:

```
notebooks/01_data_cleaning.ipynb
```

It:

- Handles missing values  
- Normalizes text  
- Fixes invalid entries  
- Extracts date and week  
- Saves cleaned file:  

```
data/connected_vehicle_usage_cleaned.csv
```

---

## 5. PostgreSQL Setup

### Create database

```sql
CREATE DATABASE connectedvehicledb;
```

### Create tables

```bash
psql -d connectedvehicledb -f sql/schema.sql
```

---

## 6. Set Environment Variable

### Windows PowerShell:

```powershell
$env:CONNECTED_VEHICLE_DB_URL="postgresql://postgres:<YOUR_PASSWORD>@localhost:5432/connectedvehicledb"
```

---

## 7. Run the ETL Pipeline

### Load cleaned data → Staging

```bash
python src/load_to_postgres.py
```

### Build Dimensions + Fact

```bash
python src/transform_to_dim_fact.py
```

### Build Daily Aggregates

```bash
python src/daily_aggregation.py
```

---

## 8. Power BI Dashboard

Open:

```
powerbi/dashboard.pbix
```

Power BI → Get Data → PostgreSQL:

```
Server: localhost
Database: connectedvehicledb
```

Select:

- agg_usage_daily  
- dim_user  
- dim_vehicle  
- dim_feature  
- fact_feature_usage  

---

## 9. Technologies Used

- **Python**
- **Jupyter Notebook**
- **PostgreSQL**
- **Power BI**
- **SQL**

---

## 10. Author

Project by **Nitish Kumar Pandey**

---
