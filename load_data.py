
import csv
import sqlite3
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
CSV_PATH = BASE_DIR / "data" / "customer_churn.csv"
DB_PATH = BASE_DIR / "data" / "churn.db"


def main():
    if not CSV_PATH.exists():
        raise FileNotFoundError(f"CSV not found: {CSV_PATH}")

    with CSV_PATH.open("r", encoding="utf-8-sig", newline="") as file:
        reader = csv.DictReader(file)
        columns = reader.fieldnames
        rows = list(reader)

    if not columns or not rows:
        raise ValueError("CSV is empty or missing headers.")

    required = {"customerID", "Churn"}
    if not required.issubset(columns):
        raise ValueError(f"Unexpected CSV headers: {columns}")

    def quote(name):
        return '"' + name.replace('"', '""') + '"'

    column_sql = ", ".join(f"{quote(c)} TEXT" for c in columns)
    column_names = ", ".join(quote(c) for c in columns)
    placeholders = ", ".join("?" for _ in columns)

    with sqlite3.connect(DB_PATH) as conn:
        conn.execute("DROP TABLE IF EXISTS customers")
        conn.execute(f"CREATE TABLE customers ({column_sql})")

        conn.executemany(
            f"INSERT INTO customers ({column_names}) VALUES ({placeholders})",
            [[row.get(c) for c in columns] for row in rows],
        )

        conn.execute(
            "CREATE INDEX idx_customer_id ON customers(customerID)"
        )

        total = conn.execute(
            "SELECT COUNT(*) FROM customers"
        ).fetchone()[0]

        churned = conn.execute(
            "SELECT COUNT(*) FROM customers WHERE Churn = 'Yes'"
        ).fetchone()[0]

        print("Database created successfully.")
        print(f"Total customers: {total}")
        print(f"Churned customers: {churned}")
        print(f"Churn rate: {churned / total:.2%}")
        print(f"Database: {DB_PATH}")
        print(f"Database size: {DB_PATH.stat().st_size:,} bytes")


if __name__ == "__main__":
    main()
