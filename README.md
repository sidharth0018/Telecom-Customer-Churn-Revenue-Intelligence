# Telecom Customer Churn & Revenue Intelligence Platform

An end-to-end data analytics portfolio project that investigates customer churn, customer segments, and recurring revenue exposure using **Python, Pandas, MySQL, SQL, Power BI, DAX, and Excel**.

> **Project status:** Starter repository. Replace the TODOs and add your own analysis, dashboard screenshots, and verified findings as you complete the project. Do not claim findings that you have not calculated from the data.

## Business problem

A telecom business wants to understand:
- What proportion of customers churn?
- Which customer groups have higher observed churn rates?
- How do contract type, tenure, services, and billing characteristics relate to churn?
- How much monthly recurring revenue is associated with customers who churned?
- Which customer segments should be investigated for retention initiatives?

This is descriptive analysis. Patterns in this dataset show associations; they do **not** prove that a feature causes churn.

## Tech stack

- **Python / Pandas:** data quality checks, cleaning, exploratory analysis
- **MySQL:** relational storage and analytical SQL
- **SQL:** joins, CTEs, aggregations, conditional logic, and window functions
- **Power BI / DAX:** KPI measures, interactive reports, and segment analysis
- **Excel:** spot checks and independent KPI reconciliation
- **Git / GitHub:** version control and project documentation

## Dataset

This project is designed for the IBM Telco Customer Churn sample dataset, commonly available on Kaggle:

- Dataset page: <https://www.kaggle.com/datasets/blastchar/telco-customer-churn>

Download the CSV from the dataset page and place it at:

```text
data/raw/WA_Fn-UseC_-Telco-Customer-Churn.csv
```

The dataset may contain a customer identifier, demographic fields, subscribed services, contract and payment details, tenure, charges, and a churn label. Check the exact column names in your downloaded file before running the scripts.

**Data note:** The dataset is commonly used for learning and portfolio analysis. Review its license and usage terms on the source page before redistribution. This repository does not include the raw dataset.

## Repository structure

```text
telecom-customer-churn-revenue-intelligence/
├── data/
│   ├── raw/                  # Place downloaded source CSV here (not committed)
│   ├── processed/            # Cleaned output (not committed)
│   └── README.md
├── notebooks/
│   └── 01_exploratory_analysis.ipynb  # Create your analysis notebook here
├── src/
│   └── clean_data.py
├── sql/
│   ├── 01_create_database.sql
│   ├── 02_analysis_queries.sql
│   └── 03_validation_queries.sql
├── powerbi/
│   └── README.md
├── reports/
│   └── findings_template.md
├── .gitignore
├── requirements.txt
└── README.md
```

## Getting started

### 1. Clone the repository

```bash
git clone https://github.com/YOUR-USERNAME/telecom-customer-churn-revenue-intelligence.git
cd telecom-customer-churn-revenue-intelligence
```

### 2. Create a virtual environment

Windows:

```bash
python -m venv .venv
.venv\Scripts\activate
```

macOS / Linux:

```bash
python -m venv .venv
source .venv/bin/activate
```

### 3. Install dependencies

```bash
pip install -r requirements.txt
```

### 4. Add the dataset

Download the CSV from the dataset source above and place it in `data/raw/`.

### 5. Run the cleaning and validation script

```bash
python src/clean_data.py
```

The script writes a cleaned CSV to `data/processed/telco_customer_churn_clean.csv` and prints basic validation summaries.

### 6. Load data into MySQL

Create the database using `sql/01_create_database.sql`, then import the processed CSV into a table named `telco_customer_churn`. You can use MySQL Workbench's **Table Data Import Wizard**. Confirm the imported row count and column types before running the queries.

### 7. Run the SQL analysis

Open and run `sql/02_analysis_queries.sql` in MySQL Workbench. Run the validation checks in `sql/03_validation_queries.sql` and reconcile key metrics with Python and Power BI.

### 8. Build the Power BI report

Follow `powerbi/README.md` for suggested pages, measures, and validation steps. Save your `.pbix` file locally; only commit it if it is reasonably sized and contains no sensitive data.

## Planned dashboard pages

1. **Executive Overview:** customers, churn rate, churned customers, monthly charges, and monthly charges associated with churned customers.
2. **Churn Drivers:** churn by contract, tenure band, internet service, payment method, and other categorical attributes.
3. **Retention Intelligence:** segment-level churn rates and revenue exposure to help prioritize further investigation.

## KPI definitions

Use these definitions consistently throughout the project:

- **Total Customers:** distinct customer count.
- **Churned Customers:** count of records where `Churn = 'Yes'`.
- **Churn Rate:** churned customers divided by total customers.
- **Monthly Charges:** sum of `MonthlyCharges` across the selected customer population.
- **Monthly Charges of Churned Customers:** sum of `MonthlyCharges` where `Churn = 'Yes'`. This is a snapshot of monthly charges associated with churned customers in this dataset, **not** a verified forecast of future lost revenue.
- **Segment Churn Rate:** churned customers in a segment divided by all customers in that segment.

## Findings and recommendations

Record only results that you have calculated and validated. Use `reports/findings_template.md` to document:
- the question,
- the method,
- the result,
- the business interpretation,
- limitations,
- a recommendation or follow-up analysis.

## Deliverables checklist

- [ ] Reproducible Python cleaning and validation
- [ ] Exploratory analysis notebook with labeled charts
- [ ] MySQL database/table and documented analytical queries
- [ ] Power BI `.pbix` file and screenshots
- [ ] KPI reconciliation between Python, SQL, and Power BI
- [ ] 5–7 validated findings with limitations
- [ ] Clear README and project demo

## Resume bullet template

Use only after completing and verifying the work. Replace bracketed values with your actual results:

> Built an end-to-end telecom churn analytics workflow using Python, Pandas, MySQL, and Power BI; cleaned and validated customer data, analyzed churn segments using SQL, and developed an interactive dashboard tracking churn KPIs and monthly charges associated with churned customers. Identified **[N] validated patterns** and documented data-backed retention recommendations.

## Limitations

- This is a sample dataset and may not represent a current telecom business.
- Churn patterns are descriptive and should not be presented as causal effects.
- Monthly charges associated with churned customers are not automatically equivalent to realized or forecast revenue loss.
- Recommendations should be framed as hypotheses to test, not guaranteed outcomes.
