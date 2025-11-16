# cariad-connected-usage-intel

An end-to-end analytics project simulating **connected vehicle usage intelligence**, similar to how CARIAD (Volkswagen Group) monitors feature usage, app stability, user behavior, and regional performance.  
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

The architecture diagram (`docs/architecture.png`) summarizes the workflow:

1. Raw CSV →  
2. Cleaned using Jupyter notebook →  
3. Loaded into PostgreSQL staging tables →  
4. Transformed into Dims + Fact →  
5. Aggregated into daily metrics →  
6. Connected to Power BI dashboard.

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