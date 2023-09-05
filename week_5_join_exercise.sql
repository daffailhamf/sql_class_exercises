-- WEEK 5 SQL JOIN EXERCISE

-- using database
USE 3_odds;

-- 1. Present product information that has been ordered!
SELECT p.productCode, p.productName, p.productLine, 
       SUM(od.quantityOrdered) as totalQuantityOrdered
FROM products p
RIGHT JOIN orderDetails od
USING (productCode)
GROUP BY productCode
ORDER BY totalQuantityOrdered DESC;

-- 2. What products are still in the processing stage, and how much these product would generate revenue?
SELECT p.productCode, p.productName, p.productLine, p.productVendor, o.status, 
       SUM(od.quantityOrdered) as quantityOrderd, SUM(od.quantityOrdered * od.priceEach) as projectedRevenue
FROM products p
JOIN orderDetails od
USING (productCode)
JOIN orders o 
USING (orderNumber)
WHERE o.status = 'In Process'
GROUP BY p.productCode
ORDER BY projectedRevenue DESC;

-- 3. Present data regarding the remaining stock of the products that have been ordered 
-- and the percentage of the product being sold to the total stock! 
-- (assume that the total stock = quantityOrdered + quantitystock)
SELECT p.productCode, p.productName, p.productLine, SUM(od.quantityOrdered) as quantityOrdered, 
	   p.quantityInStock, (SUM(od.quantityOrdered) + p.quantityInStock) as totalStock,
       SUM(od.quantityOrdered) / (SUM(od.quantityOrdered) + p.quantityInStock) * 100 as percentSold
FROM products p
JOIN orderDetails od
USING (productCode)
JOIN orders o
USING (orderNumber)
GROUP BY productCode
ORDER BY percentSold DESC;

-- 4. What products sell for 20 percent below the vendor's recommended price?
SELECT p.productCode, p.productName, p.productLine, p.productVendor, 
       p.MSRP, od.priceEach, (priceEach/MSRP *100) as percentOfMSRP
FROM products p
JOIN orderDetails od
WHERE priceEach < (MSRP * 0.8)
ORDER BY percentOfMSRP DESC;

-- 5. Present information on customers who have placed orders 
-- along with the name and number of products ordered!
SELECT c.customerNumber, c.customerName, p.productName, SUM(od.quantityOrdered) as totalQuantity
FROM products p
JOIN orderDetails od
USING (productCode)
JOIN orders o
USING (orderNumber)
JOIN customers c
USING (customerNumber)
GROUP BY c.customerNumber, p.productName;
