-- Calculate the average order amount for each country

SELECT country, AVG(priceEach * quantityOrdered) AS avg_order_value
FROM customers c
INNER JOIN orders o ON c.customerNumber = o.customerNumber
INNER JOIN orderdetails od ON o.orderNumber = od.orderNumber
Group BY country
ORDER BY avg_order_Value DESC;

-- Calculate the total sales amount for each product line

SELECT productLine, SUM(priceEach * quantityOrdered) AS sales_value
FROM orderdetails od
INNER JOIN products p ON od.productCode = p.productCode
-- INNER JOIN productlines pl ON p.productLine = pl.productLine
GROUP BY productLine;

-- List the top 10 best-selling products based on total quantity sold

SELECT productName, SUM(quantityOrdered) AS units_sold
FROM orderdetails od
INNER JOIN products p ON od.productCode = p.productCode
GROUP BY productName
ORDER BY units_sold DESC
LIMIT 10;

-- Evaluate the sales performance of each sales representative

SELECT e.firstName, e.lastname, SUM(quantityOrdered * priceEach) AS order_value
FROM employees e
INNER JOIN customers c
ON employeeNumber = salesRepEmployeeNumber AND e.jobTitle = 'Sales Rep'
LEFT JOIN orders o
ON c.customerNumber = o.customerNumber
LEFT JOIN orderdetails od
ON o.orderNumber = od.orderNumber
GROUP BY e.firstname, e.lastname;

-- Calculate the average order numbers of orders placed by each customer

SELECT COUNT(o.orderNumber)/COUNT(DISTINCT c.customerNumber)
FROM customers c
LEFT JOIN orders o
ON c.customerNumber = o.customerNumber;

-- Calculate the percentrage of orders that were shipped on time

SELECT SUM(CASE WHEN shippedDate <= requiredDate THEN 1 ELSE 0 END) / COUNT(orderNumber) *100 AS PERCENT_ON_TIME
FROM orders;

-- Calculate the profit margin for each product by subtracting the cost of goods sold (COGS) from the sales revenue

SELECT productName, SUM((priceEach*quantityOrdered) - (buyPrice*quantityOrdered)) AS net_profit
FROM products p
INNER JOIN orderdetails o
ON p.productCode = o.productCode
GROUP BY productName


-- Segmant customers based on their total purchase amount

-- Identify frequently co-purchased products to understand cross-selling opportunities

-- Estimate the CLV for each customer based on the average purchase value and purchase frequency