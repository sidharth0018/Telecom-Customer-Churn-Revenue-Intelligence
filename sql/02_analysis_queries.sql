USE telecom_churn;

-- 1. Overall customer and churn KPIs
SELECT
    COUNT(DISTINCT customerID) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(DISTINCT customerID), 0), 2
    ) AS churn_rate_pct,
    ROUND(SUM(MonthlyCharges), 2) AS total_monthly_charges,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END), 2)
        AS churned_customer_monthly_charges
FROM telco_customer_churn;

-- 2. Churn by contract
SELECT
    Contract,
    COUNT(*) AS customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * AVG(CASE WHEN Churn = 'Yes' THEN 1.0 ELSE 0.0 END), 2)
        AS churn_rate_pct
FROM telco_customer_churn
GROUP BY Contract
ORDER BY churn_rate_pct DESC;

-- 3. Churn by tenure band
SELECT
    tenure_band,
    COUNT(*) AS customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * AVG(CASE WHEN Churn = 'Yes' THEN 1.0 ELSE 0.0 END), 2)
        AS churn_rate_pct
FROM telco_customer_churn
GROUP BY tenure_band
ORDER BY MIN(tenure);

-- 4. Churn by payment method
SELECT
    PaymentMethod,
    COUNT(*) AS customers,
    ROUND(100.0 * AVG(CASE WHEN Churn = 'Yes' THEN 1.0 ELSE 0.0 END), 2)
        AS churn_rate_pct,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END), 2)
        AS churned_customer_monthly_charges
FROM telco_customer_churn
GROUP BY PaymentMethod
ORDER BY churn_rate_pct DESC;

-- 5. Churn by internet service
SELECT
    InternetService,
    COUNT(*) AS customers,
    ROUND(100.0 * AVG(CASE WHEN Churn = 'Yes' THEN 1.0 ELSE 0.0 END), 2)
        AS churn_rate_pct
FROM telco_customer_churn
GROUP BY InternetService
ORDER BY churn_rate_pct DESC;

-- 6. Revenue exposure by contract
SELECT
    Contract,
    COUNT(*) AS churned_customers,
    ROUND(SUM(MonthlyCharges), 2) AS monthly_charges_of_churned_customers
FROM telco_customer_churn
WHERE Churn = 'Yes'
GROUP BY Contract
ORDER BY monthly_charges_of_churned_customers DESC;

-- 7. Segment analysis using a CTE
WITH segment_metrics AS (
    SELECT
        Contract,
        tenure_band,
        COUNT(*) AS customers,
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
        SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END)
            AS churned_customer_monthly_charges
    FROM telco_customer_churn
    GROUP BY Contract, tenure_band
)
SELECT
    *,
    ROUND(100.0 * churned_customers / NULLIF(customers, 0), 2)
        AS churn_rate_pct
FROM segment_metrics
WHERE customers >= 30
ORDER BY churn_rate_pct DESC;

-- 8. Window function: rank contract segments by churn rate
WITH contract_metrics AS (
    SELECT
        Contract,
        COUNT(*) AS customers,
        AVG(CASE WHEN Churn = 'Yes' THEN 1.0 ELSE 0.0 END) AS churn_rate
    FROM telco_customer_churn
    GROUP BY Contract
)
SELECT
    Contract,
    customers,
    ROUND(100 * churn_rate, 2) AS churn_rate_pct,
    DENSE_RANK() OVER (ORDER BY churn_rate DESC) AS churn_rate_rank
FROM contract_metrics;

-- 9. Average charges by churn status
SELECT
    Churn,
    COUNT(*) AS customers,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges,
    ROUND(AVG(TotalCharges), 2) AS avg_total_charges,
    ROUND(AVG(tenure), 2) AS avg_tenure_months
FROM telco_customer_churn
GROUP BY Churn;

-- 10. Churn by paperless billing
SELECT
    PaperlessBilling,
    COUNT(*) AS customers,
    ROUND(100.0 * AVG(CASE WHEN Churn = 'Yes' THEN 1.0 ELSE 0.0 END), 2)
        AS churn_rate_pct
FROM telco_customer_churn
GROUP BY PaperlessBilling
ORDER BY churn_rate_pct DESC;

-- Interpretation reminder:
-- These are descriptive associations. Do not claim that a segment attribute
-- causes churn without a suitable causal design.
