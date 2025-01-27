USE fraud_db;
GO

-- List all base tables in the database
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE';


-- Count total transactions in the 'transactions' table
SELECT COUNT(*) AS total_transactions FROM transactions;


-- Retrieve the top 10 rows from the 'transactions' table for preview
SELECT TOP 10 * FROM transactions;


-- Count the number of fraudulent records (Class = 1)
SELECT COUNT(*) AS fraudulent_records
FROM transactions
WHERE Class = 1;


-- Calculate the fraud rate as a percentage
SELECT 
    (SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS fraud_rate_percentage
FROM transactions;


-- Analyze fraud by transaction amount range
SELECT 
    CASE 
        WHEN Amount_Scaled < -1 THEN 'Low'
        WHEN Amount_Scaled BETWEEN -1 AND 1 THEN 'Medium'
        ELSE 'High'
    END AS amount_range,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) AS fraudulent_transactions
FROM transactions
GROUP BY 
    CASE 
        WHEN Amount_Scaled < -1 THEN 'Low'
        WHEN Amount_Scaled BETWEEN -1 AND 1 THEN 'Medium'
        ELSE 'High'
    END;

-- Analyze daily transaction and fraud trends
SELECT 
    Transaction_Day AS transaction_day,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) AS fraudulent_transactions
FROM transactions
GROUP BY Transaction_Day
ORDER BY Transaction_Day;


SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'transactions';

SELECT 
    DATEPART(HOUR, Time) AS transaction_hour,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) AS fraudulent_transactions
FROM transactions
GROUP BY DATEPART(HOUR, Time)
ORDER BY transaction_hour;


SELECT 
    AVG(V1) AS avg_v1,
    AVG(V2) AS avg_v2,
    AVG(V3) AS avg_v3
FROM transactions
WHERE Class = 1;


SELECT 
    DATENAME(WEEKDAY, Transaction_Day) AS day_of_week,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) AS fraudulent_transactions
FROM transactions
GROUP BY DATENAME(WEEKDAY, Transaction_Day)
ORDER BY COUNT(*) DESC;


SELECT 
    Transaction_Day AS transaction_day,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) AS fraudulent_transactions,
    (SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS fraud_percentage
FROM transactions
GROUP BY Transaction_Day
ORDER BY Transaction_Day;

-- Look for transactions with unusually high amounts or suspicious activity patterns.
SELECT *
FROM transactions
WHERE Amount_Scaled > 3
ORDER BY Amount_Scaled DESC;


-- Analyze the fraud rate over different time intervals (e.g., early morning, afternoon, night).
SELECT 
    CASE 
        WHEN DATEPART(HOUR, Time) BETWEEN 0 AND 6 THEN 'Early Morning'
        WHEN DATEPART(HOUR, Time) BETWEEN 7 AND 12 THEN 'Morning'
        WHEN DATEPART(HOUR, Time) BETWEEN 13 AND 18 THEN 'Afternoon'
        ELSE 'Night'
    END AS time_range,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) AS fraudulent_transactions
FROM transactions
GROUP BY 
    CASE 
        WHEN DATEPART(HOUR, Time) BETWEEN 0 AND 6 THEN 'Early Morning'
        WHEN DATEPART(HOUR, Time) BETWEEN 7 AND 12 THEN 'Morning'
        WHEN DATEPART(HOUR, Time) BETWEEN 13 AND 18 THEN 'Afternoon'
        ELSE 'Night'
    END;

