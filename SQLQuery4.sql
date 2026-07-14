-- data cleansing and EDA

USE RetailSalesProject;
GO

DROP TABLE IF EXISTS raw_superstore;
GO

CREATE TABLE raw_superstore (
    Row_ID NVARCHAR(50),
    Order_ID NVARCHAR(50),
    Order_Date NVARCHAR(50),
    Ship_Date NVARCHAR(50),
    Ship_Mode NVARCHAR(100),
    Customer_ID NVARCHAR(50),
    Customer_Name NVARCHAR(255),
    Segment NVARCHAR(100),
    Country_Region NVARCHAR(100),
    City NVARCHAR(100),
    State_Province NVARCHAR(100),
    Postal_Code NVARCHAR(50),
    Region NVARCHAR(100),
    Product_ID NVARCHAR(100),
    Category NVARCHAR(100),
    Sub_Category NVARCHAR(100),
    Product_Name NVARCHAR(500),
    Sales NVARCHAR(100),
    Quantity NVARCHAR(50),
    Discount NVARCHAR(50),
    Profit NVARCHAR(100)
);
BULK INSERT raw_superstore
FROM 'C:\sqldata\superstore_orders.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001'
);

SELECT TOP 10 *
FROM raw_superstore;

USE RetailSalesProject;
GO

SELECT COUNT(*) AS total_rows
FROM raw_superstore;

SELECT TOP 20 *
FROM raw_superstore;

DROP TABLE IF EXISTS clean_superstore;
GO

SELECT
    TRY_CAST(Row_ID AS INT) AS Row_ID,
    Order_ID,
    TRY_CONVERT(DATE, Order_Date) AS Order_Date,
    TRY_CONVERT(DATE, Ship_Date) AS Ship_Date,
    Ship_Mode,
    Customer_ID,
    Customer_Name,
    Segment,
    Country_Region,
    City,
    State_Province,
    Postal_Code,
    Region,
    Product_ID,
    Category,
    Sub_Category,
    Product_Name,
    TRY_CAST(Sales AS FLOAT) AS Sales,
    TRY_CAST(Quantity AS INT) AS Quantity,
    TRY_CAST(Discount AS FLOAT) AS Discount,
    TRY_CAST(Profit AS FLOAT) AS Profit
INTO clean_superstore
FROM raw_superstore;

SELECT TOP 20 *
FROM clean_superstore;

SELECT COUNT(DISTINCT Customer_ID) AS total_customers
FROM clean_superstore;

SELECT COUNT(DISTINCT Product_ID) AS total_products
FROM clean_superstore;

SELECT
    SUM(Sales) AS total_sales
FROM clean_superstore;

SELECT
    SUM(Profit) AS total_profit
FROM clean_superstore;

SELECT TOP 20 Profit
FROM raw_superstore;


USE RetailSalesProject;
GO

DROP TABLE IF EXISTS raw_superstore;
GO

CREATE TABLE raw_superstore (
    Row_ID NVARCHAR(50),
    Order_ID NVARCHAR(50),
    Order_Date NVARCHAR(50),
    Ship_Date NVARCHAR(50),
    Ship_Mode NVARCHAR(100),
    Customer_ID NVARCHAR(50),
    Customer_Name NVARCHAR(255),
    Segment NVARCHAR(100),
    Country_Region NVARCHAR(100),
    City NVARCHAR(100),
    State_Province NVARCHAR(100),
    Postal_Code NVARCHAR(50),
    Region NVARCHAR(100),
    Product_ID NVARCHAR(100),
    Category NVARCHAR(100),
    Sub_Category NVARCHAR(100),
    Product_Name NVARCHAR(500),
    Sales NVARCHAR(100),
    Quantity NVARCHAR(50),
    Discount NVARCHAR(50),
    Profit NVARCHAR(100)
);
GO

BULK INSERT raw_superstore
FROM 'C:\sqldata\superstore_orders.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    ROWTERMINATOR = '0x0A'
);
GO

SELECT TOP 10
    Product_Name,
    Sales,
    Quantity,
    Discount,
    Profit
FROM raw_superstore;

DROP TABLE IF EXISTS clean_superstore;
GO

SELECT
    TRY_CAST(Row_ID AS INT) AS Row_ID,
    Order_ID,
    TRY_CONVERT(date, Order_Date, 101) AS Order_Date,
    TRY_CONVERT(date, Ship_Date, 101) AS Ship_Date,
    Ship_Mode,
    Customer_ID,
    Customer_Name,
    Segment,
    Country_Region,
    City,
    State_Province,
    Postal_Code,
    Region,
    Product_ID,
    Category,
    Sub_Category,
    Product_Name,
    TRY_CAST(Sales AS DECIMAL(18,2)) AS Sales,
    TRY_CAST(Quantity AS INT) AS Quantity,
    TRY_CAST(Discount AS DECIMAL(5,2)) AS Discount,
    TRY_CAST(Profit AS DECIMAL(18,2)) AS Profit
INTO clean_superstore
FROM raw_superstore;

SELECT TOP 10 *
FROM clean_superstore;

SELECT
    SUM(Sales) AS TotalSales,
    SUM(Profit) AS TotalProfit
FROM clean_superstore;

SELECT TOP 20 Profit
FROM clean_superstore;

SELECT TOP 20
    Profit,
    TRY_CAST(Profit AS DECIMAL(18,2)) AS NewProfit,
    TRY_CAST(Profit AS FLOAT) AS FloatProfit
FROM raw_superstore;


DROP TABLE IF EXISTS clean_superstore;
GO

SELECT
    TRY_CAST(Row_ID AS INT) AS Row_ID,
    Order_ID,
    TRY_CONVERT(date, Order_Date, 101) AS Order_Date,
    TRY_CONVERT(date, Ship_Date, 101) AS Ship_Date,
    Ship_Mode,
    Customer_ID,
    Customer_Name,
    Segment,
    Country_Region,
    City,
    State_Province,
    Postal_Code,
    Region,
    Product_ID,
    Category,
    Sub_Category,
    Product_Name,
    TRY_CAST(Sales AS DECIMAL(18,2)) AS Sales,
    TRY_CAST(Quantity AS INT) AS Quantity,
    TRY_CAST(Discount AS DECIMAL(5,2)) AS Discount,
    TRY_CAST(REPLACE(REPLACE(Profit, CHAR(13), ''), CHAR(10), '') AS DECIMAL(18,2)) AS Profit
INTO clean_superstore
FROM raw_superstore;

SELECT
    SUM(Sales) AS TotalSales,
    SUM(Profit) AS TotalProfit
FROM clean_superstore;

SELECT COUNT(*) AS TotalRows
FROM clean_superstore;

SELECT COUNT(DISTINCT Order_ID) AS TotalOrders
FROM clean_superstore;

SELECT COUNT(DISTINCT Customer_ID) AS TotalCustomers
FROM clean_superstore;

SELECT COUNT(DISTINCT Product_ID) AS TotalProducts
FROM clean_superstore;

SELECT
    MIN(Order_Date) AS FirstOrderDate,
    MAX(Order_Date) AS LastOrderDate
FROM clean_superstore;

-- Question 1: Which region generated the highest sales?
SELECT    
    Region,
    SUM(Sales) AS TotalSales
FROM clean_superstore
GROUP BY Region
ORDER BY TotalSales DESC;

-- Question 2: Which region generated the highest profit?
SELECT
    Region,
    SUM(Profit) AS TotalProfit
FROM clean_superstore
GROUP BY Region
ORDER BY TotalProfit DESC;

-- Question 3: Sales and Profit by Category
SELECT
    Category,
    SUM(Sales) AS TotalSales,
    SUM(Profit) AS TotalProfit
FROM clean_superstore
GROUP BY Category
ORDER BY TotalSales DESC;

-- Question 4: Profit by Sub-Category
SELECT
    Sub_Category,
    SUM(Sales) AS TotalSales,
    SUM(Profit) AS TotalProfit
FROM clean_superstore
GROUP BY Sub_Category
ORDER BY TotalProfit DESC;

-- Question 5: Top 10 Products by Sales
SELECT TOP 10
    Product_Name,
    SUM(Sales) AS TotalSales
FROM clean_superstore
GROUP BY Product_Name
ORDER BY TotalSales DESC;

-- Question 6: Bottom 10 Products by Profit
SELECT TOP 10
    Product_Name,
    SUM(Profit) AS TotalProfit
FROM clean_superstore
GROUP BY Product_Name
ORDER BY TotalProfit ASC;

-- Question 7: Top 10 Customers by Sales
SELECT TOP 10
    Customer_Name,
    SUM(Sales) AS TotalSales
FROM clean_superstore
GROUP BY Customer_Name
ORDER BY TotalSales DESC;

-- Question 8: Top 10 Customers by Profit
SELECT TOP 10
    Customer_Name,
    SUM(Profit) AS TotalProfit
FROM clean_superstore
GROUP BY Customer_Name
ORDER BY TotalProfit DESC;


-- sales trend analysis
-- question1: Monthly Sales Trend
SELECT
    YEAR(Order_Date) AS OrderYear,
    MONTH(Order_Date) AS OrderMonth,
    SUM(Sales) AS TotalSales
FROM clean_superstore
GROUP BY
    YEAR(Order_Date),
    MONTH(Order_Date)
ORDER BY
    OrderYear,
    OrderMonth;

 -- question2:Monthly Sales Trend
 SELECT
    YEAR(Order_Date) AS OrderYear,
    MONTH(Order_Date) AS OrderMonth,
    SUM(Profit) AS TotalProfit
FROM clean_superstore
GROUP BY
    YEAR(Order_Date),
    MONTH(Order_Date)
ORDER BY
    OrderYear,
    OrderMonth;

    -- question3:average order value
    SELECT
    AVG(Sales) AS AverageOrderValue
FROM clean_superstore;

-- question4：average discount
SELECT
    AVG(Discount) AS AverageDiscount
FROM clean_superstore;

-- question5：Sales by Ship Mode
SELECT
    Ship_Mode,
    SUM(Sales) AS TotalSales,
    SUM(Profit) AS TotalProfit
FROM clean_superstore
GROUP BY Ship_Mode
ORDER BY TotalSales DESC;

-- customer analysis
-- Business Question 1 Which customers generate the highest sales?
SELECT TOP 10
    Customer_Name,
    SUM(Sales) AS TotalSales
FROM clean_superstore
GROUP BY Customer_Name
ORDER BY TotalSales DESC;

-- Business Question 2 Which customers generate the highest profit?
SELECT TOP 10
    Customer_Name,
    SUM(Profit) AS TotalProfit
FROM clean_superstore
GROUP BY Customer_Name
ORDER BY TotalProfit DESC;

-- Business Question 3 Which customers placed the most orders?
SELECT TOP 10
    Customer_Name,
    COUNT(DISTINCT Order_ID) AS TotalOrders
FROM clean_superstore
GROUP BY Customer_Name
ORDER BY TotalOrders DESC;
-- Business Question 4 Average Sales per Customer
SELECT
    Customer_Name,
    AVG(Sales) AS AverageSales
FROM clean_superstore
GROUP BY Customer_Name
ORDER BY AverageSales DESC;

-- Business Question 5 Customer Distribution by Segment
SELECT
    Segment,
    COUNT(DISTINCT Customer_ID) AS Customers
FROM clean_superstore
GROUP BY Segment
ORDER BY Customers DESC;
-- Business Question 6 Sales by Segment
SELECT
    Segment,
    SUM(Sales) AS TotalSales,
    SUM(Profit) AS TotalProfit
FROM clean_superstore
GROUP BY Segment
ORDER BY TotalSales DESC;

-- Part 5 product analyst
-- Question 1 Which product categories generate the most revenue?

SELECT
     Category,
     SUM(Sales) AS TotalSales
FROM clean_superstore
GROUP BY Category
ORDER BY TotalSales DESC;

-- Question 2 Which product categories generate the most profit?
SELECT 
     Category,
     sum(Profit) as Totalprofits
From clean_superstore
group by Category
order by Totalprofits DESC

-- Question 3 Which sub-categories have high sales but low profit?
Select
     Sub_Category,
     SUM(Sales) as TotalSales,
     SUM(Profit) as TotalProfits
From clean_superstore
Group by Sub_Category
Order by TotalSales DESC;

-- Question 4 Top 10 products by sales
select TOP 10
     Product_Name,
     sum(Sales) as TotalSales
     from clean_superstore
     group by Product_Name
     order by TotalSales DESC;

-- Question 5 Top 10 products by profit
select top 10
      Product_Name,
      sum(Profit) as TotalProfts
      from clean_superstore
      group by Product_Name
      order by TotalProfts DESC;

-- Question 6 Bottom 10 products by profit
SELECT TOP 10
    Product_Name,
    SUM(Profit) AS TotalProfit
FROM clean_superstore
GROUP BY Product_Name
ORDER BY TotalProfit ASC;

-- Part 6 — Discount Analysis
-- Question 1 Does discount affect profitability?
select Discount,
AVG(Profit) as Avgprofit,
Avg(Sales) as AvgSales
FROM clean_superstore
Group by Discount
Order by Discount;

-- Question2 Average profit by discount level
select 
     Discount,
     sum(Profit) as TotalProfit
     From clean_superstore
     group by Discount
     order by Discount;

-- Question 3 Which discount levels lead to losses?
select 
    Discount,
    sum(Profit) as TotalProfit
    from clean_superstore
    Group by Discount
    Having sum(Profit) < 0
    order by Discount;

-- Part 7 Window Function
-- rank customer by sales
SELECT
    Customer_Name,
    SUM(Sales) AS TotalSales,
    RANK() OVER(
        ORDER BY SUM(Sales) DESC
    ) AS SalesRank
FROM clean_superstore
GROUP BY Customer_Name;
-- Rank products within each category
SELECT
    Category,
    Product_Name,
    SUM(Sales) AS TotalSales,
    RANK() OVER(
        PARTITION BY Category
        ORDER BY SUM(Sales) DESC
    ) AS CategoryRank
FROM clean_superstore
GROUP BY Category, Product_Name;

-- 