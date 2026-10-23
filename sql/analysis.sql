
-- 1. Overall churn summary
SELECT
    Churn,
    COUNT(*) AS customer_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM customers), 2)
        AS percentage
FROM customers
GROUP BY Churn;


-- 2. Churn by contract type
SELECT
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS churn_rate_pct
FROM customers
GROUP BY Contract
ORDER BY churn_rate_pct DESC;


-- 3. Churn by customer tenure
SELECT
    CASE
        WHEN CAST(tenure AS INTEGER) < 12 THEN '0-11 months'
        WHEN CAST(tenure AS INTEGER) < 24 THEN '12-23 months'
        WHEN CAST(tenure AS INTEGER) < 48 THEN '24-47 months'
        ELSE '48+ months'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS churn_rate_pct
FROM customers
GROUP BY tenure_group
ORDER BY MIN(CAST(tenure AS INTEGER));


-- 4. Churn by payment method
SELECT
    PaymentMethod,
    COUNT(*) AS total_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS churn_rate_pct
FROM customers
GROUP BY PaymentMethod
ORDER BY churn_rate_pct DESC;


-- 5. Monthly charges: churned vs retained customers
SELECT
    Churn,
    COUNT(*) AS customer_count,
    ROUND(AVG(CAST(MonthlyCharges AS REAL)), 2) AS avg_monthly_charges,
    ROUND(AVG(CAST(tenure AS INTEGER)), 1) AS avg_tenure_months
FROM customers
GROUP BY Churn;


-- 6. Rank contract types by churn rate
WITH contract_metrics AS (
    SELECT
        Contract,
        COUNT(*) AS total_customers,
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
        1.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
            / COUNT(*) AS churn_rate
    FROM customers
    GROUP BY Contract
)
SELECT
    Contract,
    total_customers,
    churned,
    ROUND(churn_rate * 100, 2) AS churn_rate_pct,
    RANK() OVER (ORDER BY churn_rate DESC) AS churn_risk_rank
FROM contract_metrics
ORDER BY churn_risk_rank;


-- 7. Monthly charges associated with churned customers
SELECT
    Contract,
    COUNT(*) AS churned_customers,
    ROUND(SUM(CAST(MonthlyCharges AS REAL)), 2)
        AS monthly_charges_of_churned_customers,
    ROUND(AVG(CAST(MonthlyCharges AS REAL)), 2)
        AS avg_monthly_charge
FROM customers
WHERE Churn = 'Yes'
GROUP BY Contract
ORDER BY monthly_charges_of_churned_customers DESC;
