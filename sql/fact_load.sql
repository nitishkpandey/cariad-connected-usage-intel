INSERT INTO fact_feature_usage (
    user_sk,
    vehicle_sk,
    feature_sk,
    feature_used_at,
    session_duration_min,
    error_flag,
    feedback_rating,
    app_version,
    os_type
)
SELECT
    u.user_sk,
    v.vehicle_sk,
    f.feature_sk,
    s.feature_used_at,
    s.session_duration_min,
    s.error_flag,
    s.feedback_rating,
    s.app_version,
    s.os_type
FROM stg_feature_usage s
LEFT JOIN dim_user u    ON s.user_id = u.user_id
LEFT JOIN dim_vehicle v ON s.vehicle_model = v.vehicle_model
LEFT JOIN dim_feature f ON s.feature_name = f.feature_name;