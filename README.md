# Churn Detective — Customer Retention Analysis Using SQL

## Overview

Churn Detective is a SQL-based customer analytics project that examines customer churn patterns in a telecommunications sample dataset. It identifies customer segments associated with higher churn and translates the findings into actionable business recommendations.

## Dataset

- **Source:** IBM Telco Customer Churn sample dataset
- **Records:** 7,043 customers
- **Target variable:** `Churn`
- **Database:** SQLite

The dataset represents a fictional telecommunications business and is intended for analytical and educational use.

## Tools and Skills

- SQL and SQLite
- Python's built-in `sqlite3` and `csv` modules
- Data validation and database creation
- Aggregations, conditional logic, CTEs, and window functions
- Customer segmentation and KPI analysis

## Key Findings

- Overall churn rate: **26.54%** (1,869 of 7,043 customers).
- Month-to-month customers had a churn rate of **42.71%**, compared with **2.83%** for two-year contract customers.
- Customers with less than 12 months of tenure had a churn rate of **48.28%**.
- Customers using electronic checks had a churn rate of **45.29%**.
- Churned customers had higher average monthly charges (**74.44**) than retained customers (**61.27**) and lower average tenure (**18.0 versus 37.6 months**).

## Business Recommendations

1. Investigate early-tenure churn and improve onboarding and customer support.
2. Evaluate retention offers and longer-term contract options for month-to-month customers.
3. Investigate the relationship between electronic-check payments and churn.
4. Review pricing, service bundles, and customer feedback among customers with higher monthly charges.

These findings describe associations in the sample and do not establish causal relationships.

## Project Structure

```
ChurnDetective/
├── data/
│   └── customer_churn.csv
├── sql/
│   └── analysis.sql
├── results/
├── load_data.py
├── run_analysis.py
├── .gitignore
└── README.md
```

The SQLite database is created locally by `load_data.py` and is not committed to the repository.

## How to Run

1. Install Python 3.13 or another compatible Python 3 version.
2. Ensure `customer_churn.csv` is inside the `data` folder.
3. Run the following commands from the project root:

```
python load_data.py
python run_analysis.py
```

No third-party Python packages are required.

## Limitations

This is a sample dataset, not verified production customer data. The analysis is descriptive; further investigation would be required to determine why customers churn and whether retention interventions would be effective.