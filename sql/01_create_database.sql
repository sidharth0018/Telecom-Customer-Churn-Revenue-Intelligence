-- Run in MySQL Workbench.
CREATE DATABASE IF NOT EXISTS telecom_churn;
USE telecom_churn;

-- Import the cleaned CSV into a table named telco_customer_churn.
-- Suggested types (adjust to the exact CSV columns and MySQL version):
-- customerID VARCHAR(20) PRIMARY KEY
-- gender VARCHAR(20), SeniorCitizen TINYINT, Partner VARCHAR(5),
-- Dependents VARCHAR(5), tenure INT, PhoneService VARCHAR(5),
-- MultipleLines VARCHAR(30), InternetService VARCHAR(30),
-- OnlineSecurity VARCHAR(5), OnlineBackup VARCHAR(5),
-- DeviceProtection VARCHAR(5), TechSupport VARCHAR(5),
-- StreamingTV VARCHAR(5), StreamingMovies VARCHAR(5),
-- Contract VARCHAR(30), PaperlessBilling VARCHAR(5),
-- PaymentMethod VARCHAR(50), MonthlyCharges DECIMAL(10,2),
-- TotalCharges DECIMAL(12,2), Churn VARCHAR(5),
-- tenure_band VARCHAR(10), churned_monthly_charges DECIMAL(10,2)
