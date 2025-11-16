-- Rebuild daily aggregates

TRUNCATE agg_usage_daily;

INSERT INTO agg_usage_daily (
    feature_used_date,
    region,
    feature_name,
    app_version,
    os_type,
    dau,
    events,
    error_events,
    avg_session,
    error_rate_pct
)
SELECT
    DATE(fact.feature_used_at) AS feature_used_date,
    u.region,
    feat.feature_name,
    fact.app_version,
    fact.os_type,
    COUNT(DISTINCT u.user_id) AS dau,
    COUNT(*) AS events,
    SUM(CASE WHEN fact.error_flag = 1 THEN 1 ELSE 0 END) AS error_events,
    AVG(fact.session_duration_min) AS avg_session,
    ROUND(
        SUM(CASE WHEN fact.error_flag = 1 THEN 1 ELSE 0 END) * 100.0 
        / NULLIF(COUNT(*), 0),
        2
    ) AS error_rate_pct
FROM fact_feature_usage fact
JOIN dim_user u     ON fact.user_sk = u.user_sk
JOIN dim_feature feat ON fact.feature_sk = feat.feature_sk
GROUP BY 1,2,3,4,5
ORDER BY 1,2,3;