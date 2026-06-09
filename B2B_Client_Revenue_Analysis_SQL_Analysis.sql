-- =========================================================
-- PROJECT: B2B CLIENT REVENUE ANALYSIS
-- OBJECTIVE:
-- Analyze client revenue, profitability, sales channels,
-- industries, and client performance using SQL.
-- =========================================================

-- =========================================================
-- 1. TOTAL REVENUE GENERATED
-- =========================================================

SELECT
    ROUND(SUM(Revenue),2) AS Total_Revenue
FROM b2b_sales;

-- =========================================================
-- 2. TOTAL PROFIT GENERATED
-- =========================================================

SELECT
    ROUND(SUM(Profit),2) AS Total_Profit
FROM b2b_sales;

-- =========================================================
-- 3. REVENUE BY INDUSTRY
-- =========================================================

SELECT
    Industry,
    ROUND(SUM(Revenue),2) AS Revenue
FROM b2b_sales
GROUP BY Industry
ORDER BY Revenue DESC;

-- =========================================================
-- 4. PROFIT BY INDUSTRY
-- =========================================================

SELECT
    Industry,
    ROUND(SUM(Profit),2) AS Profit
FROM b2b_sales
GROUP BY Industry
ORDER BY Profit DESC;

-- =========================================================
-- 5. REVENUE BY CLIENT TIER
-- =========================================================

SELECT
    Client_Tier,
    ROUND(SUM(Revenue),2) AS Revenue
FROM b2b_sales
GROUP BY Client_Tier
ORDER BY Revenue DESC;

-- =========================================================
-- 6. REVENUE BY SALES CHANNEL
-- =========================================================

SELECT
    Sales_Channel,
    ROUND(SUM(Revenue),2) AS Revenue
FROM b2b_sales
GROUP BY Sales_Channel
ORDER BY Revenue DESC;

-- =========================================================
-- 7. TOP 10 CLIENTS BY REVENUE
-- =========================================================

SELECT
    Client_ID,
    ROUND(SUM(Revenue),2) AS Revenue
FROM b2b_sales
GROUP BY Client_ID
ORDER BY Revenue DESC
LIMIT 10;

-- =========================================================
-- 8. TOP 10 CLIENTS BY PROFIT
-- =========================================================

SELECT
    Client_ID,
    ROUND(SUM(Profit),2) AS Profit
FROM b2b_sales
GROUP BY Client_ID
ORDER BY Profit DESC
LIMIT 10;

-- =========================================================
-- 9. TOP CITIES BY REVENUE
-- =========================================================

SELECT
    City,
    ROUND(SUM(Revenue),2) AS Revenue
FROM b2b_sales
GROUP BY City
ORDER BY Revenue DESC;

-- =========================================================
-- 10. PRODUCT CATEGORY PERFORMANCE
-- =========================================================

SELECT
    Product_Category,
    ROUND(SUM(Revenue),2) AS Revenue,
    ROUND(SUM(Profit),2) AS Profit
FROM b2b_sales
GROUP BY Product_Category
ORDER BY Revenue DESC;

-- =========================================================
-- 11. CLIENTS GENERATING MORE THAN AVERAGE REVENUE
-- (CTE)
-- =========================================================

WITH ClientRevenue AS
(
    SELECT
        Client_ID,
        SUM(Revenue) AS Revenue
    FROM b2b_sales
    GROUP BY Client_ID
)

SELECT *
FROM ClientRevenue
WHERE Revenue >
(
    SELECT AVG(Revenue)
    FROM ClientRevenue
);

-- =========================================================
-- 12. CLIENT REVENUE RANKING
-- (WINDOW FUNCTION)
-- =========================================================

SELECT
    Client_ID,
    SUM(Revenue) AS Revenue,
    RANK() OVER(
        ORDER BY SUM(Revenue) DESC
    ) AS Revenue_Rank
FROM b2b_sales
GROUP BY Client_ID;

-- =========================================================
-- 13. TOP CLIENT PER INDUSTRY
-- (CTE + WINDOW FUNCTION)
-- =========================================================

WITH IndustryRanking AS
(
    SELECT
        Industry,
        Client_ID,
        SUM(Revenue) AS Revenue,
        ROW_NUMBER() OVER(
            PARTITION BY Industry
            ORDER BY SUM(Revenue) DESC
        ) AS Rank_No
    FROM b2b_sales
    GROUP BY Industry, Client_ID
)

SELECT *
FROM IndustryRanking
WHERE Rank_No = 1;

-- =========================================================
-- 14. MONTHLY REVENUE TREND
-- =========================================================

SELECT
    DATE_FORMAT(Order_Date,'%Y-%m') AS Month,
    ROUND(SUM(Revenue),2) AS Revenue
FROM b2b_sales
GROUP BY Month
ORDER BY Month;

-- =========================================================
-- 15. RUNNING REVENUE TOTAL
-- (WINDOW FUNCTION)
-- =========================================================

SELECT
    Order_Date,
    Revenue,
    SUM(Revenue) OVER(
        ORDER BY Order_Date
    ) AS Running_Revenue
FROM b2b_sales;

-- =========================================================
-- 16. MONTH-OVER-MONTH REVENUE GROWTH
-- (LAG FUNCTION)
-- =========================================================

WITH MonthlyRevenue AS
(
    SELECT
        DATE_FORMAT(Order_Date,'%Y-%m') AS Month,
        SUM(Revenue) AS Revenue
    FROM b2b_sales
    GROUP BY Month
)

SELECT
    Month,
    Revenue,
    LAG(Revenue) OVER(
        ORDER BY Month
    ) AS Previous_Month_Revenue
FROM MonthlyRevenue;

-- =========================================================
-- 17. REVENUE CONTRIBUTION %
-- =========================================================

SELECT
    Industry,
    ROUND(SUM(Revenue),2) AS Revenue,
    ROUND(
        SUM(Revenue) * 100 /
        (SELECT SUM(Revenue) FROM b2b_sales),
        2
    ) AS Revenue_Percentage
FROM b2b_sales
GROUP BY Industry
ORDER BY Revenue DESC;

-- =========================================================
-- 18. MOST PROFITABLE CLIENTS
-- =========================================================

SELECT
    Client_ID,
    ROUND(SUM(Profit),2) AS Profit
FROM b2b_sales
GROUP BY Client_ID
ORDER BY Profit DESC
LIMIT 20;

-- =========================================================
-- 19. AVERAGE REVENUE PER CLIENT
-- =========================================================

SELECT
    ROUND(AVG(Client_Revenue),2) AS Avg_Revenue_Per_Client
FROM
(
    SELECT
        Client_ID,
        SUM(Revenue) AS Client_Revenue
    FROM b2b_sales
    GROUP BY Client_ID
) x;

-- =========================================================
-- 20. INDUSTRY MARKET SHARE RANKING
-- =========================================================

SELECT
    Industry,
    SUM(Revenue) AS Revenue,
    DENSE_RANK() OVER(
        ORDER BY SUM(Revenue) DESC
    ) AS Industry_Rank
FROM b2b_sales
GROUP BY Industry;