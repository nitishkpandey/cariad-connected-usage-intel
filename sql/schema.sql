
DROP TABLE IF EXISTS agg_usage_daily;
DROP TABLE IF EXISTS fact_feature_usage;
DROP TABLE IF EXISTS dim_feature;
DROP TABLE IF EXISTS dim_vehicle;
DROP TABLE IF EXISTS dim_user;
DROP TABLE IF EXISTS stg_feature_usage;

-- 1. Staging table: raw events
CREATE TABLE IF NOT EXISTS stg_feature_usage (
    user_id VARCHAR(16),
    region VARCHAR(50),
    vehicle_model VARCHAR(50),
    feature_name VARCHAR(100),
    session_duration_min FLOAT,
    error_flag INT,
    feedback_rating FLOAT,
    app_version VARCHAR(20),
    os_type VARCHAR(20),
    subscription_status VARCHAR(20),
    feature_used_at TIMESTAMP
);

-- 2. Dimension tables
CREATE TABLE IF NOT EXISTS dim_user (
    user_sk SERIAL PRIMARY KEY,
    user_id VARCHAR(16) UNIQUE,
    region VARCHAR(50),
    subscription_status VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS dim_vehicle (
    vehicle_sk SERIAL PRIMARY KEY,
    vehicle_model VARCHAR(50) UNIQUE
);

CREATE TABLE IF NOT EXISTS dim_feature (
    feature_sk SERIAL PRIMARY KEY,
    feature_name VARCHAR(100) UNIQUE
);

-- 3. Fact table
CREATE TABLE IF NOT EXISTS fact_feature_usage (
    usage_sk SERIAL PRIMARY KEY,
    user_sk INT REFERENCES dim_user(user_sk),
    vehicle_sk INT REFERENCES dim_vehicle(vehicle_sk),
    feature_sk INT REFERENCES dim_feature(feature_sk),
    feature_used_at TIMESTAMP,
    session_duration_min FLOAT,
    error_flag INT,
    feedback_rating FLOAT,
    app_version VARCHAR(20),
    os_type VARCHAR(20)
);

-- 4. Aggregate table (daily stats)
CREATE TABLE IF NOT EXISTS agg_usage_daily (
    feature_used_date DATE,
    region VARCHAR(50),
    feature_name VARCHAR(100),
    app_version VARCHAR(20),
    os_type VARCHAR(20),
    dau INT,
    events INT,
    error_events INT,
    avg_session FLOAT,
    error_rate_pct FLOAT
);

ALTER TABLE stg_feature_usage
ADD COLUMN date DATE,
ADD COLUMN week INT;