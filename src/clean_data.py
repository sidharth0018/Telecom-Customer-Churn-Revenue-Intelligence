"""Clean and validate the IBM Telco Customer Churn sample CSV.

Run from the repository root:
    python src/clean_data.py
"""
from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
INPUT_PATH = ROOT / "data" / "raw" / "WA_Fn-UseC_-Telco-Customer-Churn.csv"
OUTPUT_PATH = ROOT / "data" / "processed" / "telco_customer_churn_clean.csv"

REQUIRED_COLUMNS = {
    "customerID", "tenure", "MonthlyCharges", "TotalCharges", "Churn"
}

def main() -> None:
    if not INPUT_PATH.exists():
        raise FileNotFoundError(
            f"Dataset not found: {INPUT_PATH}\n"
            "Download the CSV and place it in data/raw/."
        )

    df = pd.read_csv(INPUT_PATH)
    missing_columns = REQUIRED_COLUMNS - set(df.columns)
    if missing_columns:
        raise ValueError(
            "Unexpected dataset schema. Missing columns: "
            + ", ".join(sorted(missing_columns))
        )

    print(f"Rows loaded: {len(df):,}")
    print(f"Columns loaded: {len(df.columns):,}")

    # Standardize column labels and whitespace in text columns.
    df.columns = [c.strip() for c in df.columns]
    for col in df.select_dtypes(include="object").columns:
        df[col] = df[col].map(lambda x: x.strip() if isinstance(x, str) else x)

    # Convert numeric fields; blank TotalCharges values become NaN.
    for col in ["tenure", "MonthlyCharges", "TotalCharges"]:
        df[col] = pd.to_numeric(df[col], errors="coerce")

    duplicate_ids = int(df["customerID"].duplicated().sum())
    print(f"Duplicate customer IDs: {duplicate_ids}")

    # Keep one record per customer only if duplicates exist; log the action.
    if duplicate_ids:
        df = df.drop_duplicates(subset=["customerID"], keep="first").copy()
        print(f"Rows after duplicate customer removal: {len(df):,}")

    missing_before = df[["tenure", "MonthlyCharges", "TotalCharges"]].isna().sum()
    print("Missing numeric values before handling:")
    print(missing_before.to_string())

    # Do not impute TotalCharges blindly. For tenure 0, a blank/zero total
    # can be valid depending on the source. Preserve missing values and report.
    df["tenure_band"] = pd.cut(
        df["tenure"],
        bins=[-1, 6, 12, 24, 48, 72],
        labels=["0-6", "7-12", "13-24", "25-48", "49-72"],
        include_lowest=True,
    )

    # Helpful analysis field; this is an observed monthly-charge exposure,
    # not a forecast of future revenue loss.
    df["churned_monthly_charges"] = df["MonthlyCharges"].where(
        df["Churn"].eq("Yes"), 0
    )

    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(OUTPUT_PATH, index=False)

    print(f"\nSaved cleaned data: {OUTPUT_PATH}")
    print(f"Final rows: {len(df):,}")
    print(f"Churn values:\n{df['Churn'].value_counts(dropna=False).to_string()}")
    print(f"Churn rate: {df['Churn'].eq('Yes').mean():.2%}")
    print(f"Missing TotalCharges after conversion: {df['TotalCharges'].isna().sum()}")

if __name__ == "__main__":
    main()
