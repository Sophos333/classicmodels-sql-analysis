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

-- Calculate the percentage of orders that were shipped on time

SELECT SUM(CASE WHEN shippedDate <= requiredDate THEN 1 ELSE 0 END) / COUNT(orderNumber) *100 AS PERCENT_ON_TIME
FROM orders;

-- Calculate the profit margin for each product by subtracting the cost of goods sold (COGS) from the sales revenue

SELECT productName, SUM((priceEach*quantityOrdered) - (buyPrice*quantityOrdered)) AS net_profit
FROM products p
INNER JOIN orderdetails o
ON p.productCode = o.productCode
GROUP BY productName;


-- Segment customers based on their total purchase amount

SELECT c.*, t2.customer_segment
FROM customers c
LEFT JOIN
(SELECT *,
CASE WHEN total_purchase_value > 100000 THEN 'High Value'
     WHEN total_purchase_value BETWEEN  50000 AND 100000 THEN 'Medium Value'
     WHEN total_purchase_value <  50000 THEN 'Low Value'
ELSE 'Other' END AS customer_segment
FROM
(SELECT customerNumber, SUM(priceEach * quantityOrdered) AS total_purchase_value
FROM orders o
INNER JOIN orderdetails od
ON o.orderNumber = od.orderNumber
GROUP BY customerNumber)T1
)T2
ON c.customernumber = t2.customernumber;

-- Identify frequently co-purchased products to understand cross-selling opportunities

SELECT od.productCode, p.productName, od2.productCode, p2.productName,COUNT(*) AS purchased_together
FROM orderdetails od
INNER JOIN orderdetails od2
ON od.orderNumber = od2.orderNumber AND od.productCode <> od2.productCode
INNER JOIN products p
ON od.productCode = p.productCode
INNER JOIN products p2
ON od2.productCode = p2.productCode
GROUP BY od.productCode, p.productName, od2.productCode, p2.productName
ORDER BY purchased_together DESC;


-- Estimate the CLV for each customer based on the average purchase value and purchase frequency, and limit to top 10

SELECT
c.customerName,
COUNT(DISTINCT o.orderNumber) AS total_orders,
SUM(od.quantityOrdered * od.priceEach) / COUNT(DISTINCT o.orderNumber) AS avg_order_value,
ROUND(
(SUM(od.quantityOrdered * od.priceEach) / COUNT(DISTINCT o.orderNumber)) * COUNT(DISTINCT o.orderNumber),
2
) AS estimated_clv
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY c.customerName
ORDER BY estimated_clv DESC
LIMIT 10;


