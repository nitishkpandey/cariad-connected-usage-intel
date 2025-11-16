-- dim_user
INSERT INTO dim_user (user_id, region, subscription_status)
SELECT DISTINCT user_id, region, subscription_status
FROM stg_feature_usage
WHERE user_id IS NOT NULL
ON CONFLICT (user_id) DO NOTHING;

-- dim_vehicle
INSERT INTO dim_vehicle (vehicle_model)
SELECT DISTINCT vehicle_model
FROM stg_feature_usage
WHERE vehicle_model IS NOT NULL
ON CONFLICT (vehicle_model) DO NOTHING;

-- dim_feature
INSERT INTO dim_feature (feature_name)
SELECT DISTINCT feature_name
FROM stg_feature_usage
WHERE feature_name IS NOT NULL
ON CONFLICT (feature_name) DO NOTHING;