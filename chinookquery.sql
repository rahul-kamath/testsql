SELECT 
    c.FirstName ||' '|| c.LastName as FullName,
    ROUND(AVG(i.Total),1) AS AvgInvoiceTotal
FROM Customer c
INNER JOIN Invoice i 
ON c.CustomerID = i.CustomerID
GROUP BY c.CustomerID
HAVING AvgInvoiceTotal > 6
ORDER BY AvgInvoiceTotal DESC;

SELECT 
    c.FirstName ||' '|| c.LastName as FullName,
    COUNT(i.InvoiceID) AS NumberOfInvoices
FROM Customer c
INNER JOIN Invoice i 
ON c.CustomerID = i.CustomerID
GROUP BY c.CustomerID
ORDER BY NumberOfInvoices DESC 
LIMIT 10;

SELECT 
    c.FirstName ||' '|| c.LastName as FullName,
    ROUND(SUM(i.Total),1) AS InvoiceTotal
FROM Customer c
INNER JOIN Invoice i 
ON c.CustomerID = i.CustomerID
GROUP BY c.CustomerID
ORDER BY InvoiceTotal DESC 
LIMIT 10;

SELECT 
    c.Country,
    SUM(i.Total) AS TotalSales
FROM Customer c
INNER JOIN Invoice i 
ON c.CustomerID = i.CustomerID
GROUP BY c.Country
ORDER BY TotalSales DESC;

WITH TotalSalesByMonth AS (
    SELECT 
        STRFTIME('%m', InvoiceDate) AS Month,
        SUM(Total) AS TotalSales 
FROM Invoice
WHERE STRFTIME('%Y', InvoiceDate)='2021'
GROUP BY Month
ORDER BY Month
)
SELECT *
FROM TotalSalesbyMonth;
        

SELECT
    MIN(InvoiceDate) AS MinInvoiceDate,
    MAX(InvoiceDate) AS MaxInvoiceDate,
    COUNT(*) AS InvoiceCount
FROM Invoice;

SELECT 
    c.FirstName ||' '|| c.LastName AS FullName,
    i.InvoiceDate,
    ROUND(i.Total) AS InvoiceTotal,
    SUM(i.Total) OVER (
        PARTITION BY c.CustomerID
        ORDER BY i.InvoiceDate
        ) AS RunningTotal
FROM Customer c
INNER JOIN Invoice AS i 
ON c.CustomerID = i.CustomerID
ORDER BY
    FullName,
    i.InvoiceDate;

WITH CustomerName AS (
    SELECT 
        FirstName ||' '|| LastName AS FullName,
        Country,
        CustomerID
    FROM Customer
    ),
    Spending AS (
    SELECT
        CustomerID,
        SUM(Total) AS TotalSpending
    FROM Invoice
    GROUP BY CustomerID
    )
SELECT 
    CustomerName.FullName,
    CustomerName.Country,
    ROUND(Spending.TotalSpending,2) AS TotalSpending
FROM CustomerName
INNER JOIN Spending 
ON CustomerName.CustomerID = Spending.CustomerID
ORDER BY
    TotalSpending DESC;
    
WITH CustomerSpending AS (
    SELECT 
        c.FirstName ||' '|| c.LastName AS FullName,
        c.Country,
        SUM(i.Total) AS TotalSpending
    FROM Customer c
    INNER JOIN Invoice i
    ON c.CustomerID = i.CustomerID
    GROUP BY Country, c.CustomerID
    ),
RankedSpending AS (
    SELECT Country, FullName, TotalSpending,
        RANK() OVER (PARTITION BY Country ORDER BY TotalSpending DESC) AS SpendingRank
    FROM CustomerSpending)
    
SELECT Country, FullName, TotalSpending
FROM RankedSpending
WHERE SpendingRank = 1;











