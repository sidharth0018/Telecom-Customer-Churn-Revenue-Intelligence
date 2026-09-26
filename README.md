# Power BI report guide

## Recommended report pages

### 1. Executive Overview
- Total Customers
- Churned Customers
- Churn Rate
- Total Monthly Charges
- Monthly Charges of Churned Customers
- Churn rate by tenure band or contract

### 2. Churn Drivers
- Churn rate by Contract
- Churn rate by InternetService
- Churn rate by PaymentMethod
- Churn rate by tenure band
- Churn rate by PaperlessBilling
- Add slicers for Contract, InternetService, PaymentMethod, and tenure band

### 3. Retention Intelligence
- Matrix: Contract × tenure band
- Customer count, churn rate, and monthly charges of churned customers
- Highlight low-volume segments so a high percentage is not interpreted without context
- Add a table with evidence-based observations and recommended follow-up questions

## Suggested DAX measures

Adjust table/column names to match your Power BI model.

```DAX
Total Customers =
DISTINCTCOUNT(telco_customer_churn[customerID])

Churned Customers =
CALCULATE(
    [Total Customers],
    telco_customer_churn[Churn] = "Yes"
)

Churn Rate =
DIVIDE([Churned Customers], [Total Customers], 0)

Total Monthly Charges =
SUM(telco_customer_churn[MonthlyCharges])

Churned Customer Monthly Charges =
CALCULATE(
    SUM(telco_customer_churn[MonthlyCharges]),
    telco_customer_churn[Churn] = "Yes"
)

Average Monthly Charges =
AVERAGE(telco_customer_churn[MonthlyCharges])
```

Format `Churn Rate` as a percentage.

## Design and validation checklist

- Use consistent number formats and titles.
- Include the date/source of the dataset in a report information tooltip or footer.
- Label monthly charges for churned customers as an observed snapshot, not a forecast.
- Reconcile card values against `sql/03_validation_queries.sql`.
- Test slicers and cross-filtering.
- Include accessible labels and avoid relying on color alone.
- Save screenshots in `powerbi/screenshots/` for your GitHub README.
