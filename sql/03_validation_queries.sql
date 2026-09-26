USE telecom_churn;

-- Row count and unique customer count should be reconciled with Python.
SELECT COUNT(*) AS row_count,
       COUNT(DISTINCT customerID) AS unique_customers
FROM telco_customer_churn;

-- Check duplicate IDs (expected to be zero after cleaning).
SELECT customerID, COUNT(*) AS records
FROM telco_customer_churn
GROUP BY customerID
HAVING COUNT(*) > 1;

-- Check missing / invalid key fields.
SELECT
    SUM(customerID IS NULL OR customerID = '') AS missing_customer_id,
    SUM(Churn IS NULL OR Churn NOT IN ('Yes', 'No')) AS invalid_churn,
    SUM(MonthlyCharges IS NULL) AS missing_monthly_charges,
    SUM(tenure IS NULL) AS missing_tenure
FROM telco_customer_churn;

-- Reconcile churn counts and charges.
SELECT
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(MonthlyCharges), 2) AS all_monthly_charges,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END), 2)
        AS churned_customer_monthly_charges
FROM telco_customer_churn;
