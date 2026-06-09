-- =========================================================
-- DATA QUALITY ASSESSMENT & CLEANING
-- =========================================================

-- Check for NULL values

SELECT *
FROM b2b_sales
WHERE Revenue IS NULL
   OR Profit IS NULL
   OR Client_ID IS NULL;

-- =========================================================

-- Check duplicate invoices

SELECT
    Invoice_ID,
    COUNT(*) AS Duplicate_Count
FROM b2b_sales
GROUP BY Invoice_ID
HAVING COUNT(*) > 1;

-- =========================================================

-- Check negative revenue

SELECT *
FROM b2b_sales
WHERE Revenue < 0;

-- =========================================================

-- Check negative profit

SELECT *
FROM b2b_sales
WHERE Profit < 0;

-- =========================================================

-- Standardize Client Tier values

UPDATE b2b_sales
SET Client_Tier = TRIM(Client_Tier);

-- =========================================================

-- Verify date range

SELECT
    MIN(Order_Date) AS First_Order,
    MAX(Order_Date) AS Last_Order
FROM b2b_sales;

-- =========================================================

-- Check missing industries

SELECT *
FROM b2b_sales
WHERE Industry IS NULL;