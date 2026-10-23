
import sqlite3
from pathlib import Path

base = Path(__file__).resolve().parent
db_path = base / "data" / "churn.db"
sql_path = base / "sql" / "analysis.sql"

with sqlite3.connect(db_path) as conn:
    row_count = conn.execute(
        "SELECT COUNT(*) FROM customers"
    ).fetchone()[0]
    print(f"Verified customer records: {row_count}")

    queries = sql_path.read_text(encoding="utf-8")
    statements = [q.strip() for q in queries.split(";") if q.strip()]

    for number, statement in enumerate(statements, start=1):
        cursor = conn.execute(statement)
        columns = [item[0] for item in cursor.description]
        rows = cursor.fetchall()

        print(f"\n{'=' * 15} QUERY {number} {'=' * 15}")
        print(" | ".join(columns))
        for row in rows:
            print(" | ".join(str(value) for value in row))
