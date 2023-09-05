-- 6th MEET, SUBQUERY EXERCISE

-- using database
USE 3_odds;


-- 1. Create a query to display the highest payment amount!
SELECT *
FROM payments
WHERE amount = (SELECT MAX(amount) FROM payments);

-- 2. Write a query to display all customers whose payments exceed the average payment of all payments!
SELECT c.customerNumber, c.customerName, c.phone, c.country, c.city, c.postalCode, 
	   c.creditLimit, SUM(p.amount) as totalPayment
FROM customers c
RIGHT JOIN payments p
USING (customerNumber)
GROUP BY c.customerNumber
HAVING totalPayment > (SELECT AVG(amount) FROM payments)
ORDER BY totalPayment DESC;

-- 3. Create a query to display all customers who have made payments and are from California ('CA')!
SELECT DISTINCT(c.customerNumber), c.customerName, c.country, c.state
FROM customers c
RIGHT JOIN payments p
USING (customerNumber)
WHERE c.state = 'CA';

-- 4. Present customers data who have not made a payment!
SELECT DISTINCT(c.customerNumber), c.customerName, CONCAT(c.contactFirstName, ' ', c.contactLastName) as contactName,
	   c.phone, c.country, c.state, c.postalCode, p.amount
FROM customers c
LEFT JOIN payments p
USING (customerNumber)
WHERE p.customerNumber is NULL
ORDER BY customerNumber;

-- 5. Create a query to display employees who work in America!
SELECT e.employeeNumber, CONCAT(e.firstName, ' ', e.lastName) as fullName, o.officeCode,
       o.country, o.city, o.postalCode, o.territory
FROM employees e
JOIN offices o
USING (officeCode)
WHERE o.country = 'USA';

-- 6. Of all the payment data, on which day do most of the payment processes take place?
SELECT DAYNAME(paymentDate) as paymentDay, COUNT(DAYNAME(paymentDate)) as freq
FROM payments
GROUP BY DAYNAME(paymentDate)
ORDER BY freq DESC;

-- 7. Using CTE, create a query to display data on the top 5 employees 
-- who generated the most sales in 2003!
-- (Make sure the order status has been shipped (shipped))
WITH customerssales AS (
   SELECT c.customerNumber, SUM(od.quantityOrdered * od.priceEach) as totalSales, c.salesRepEmployeeNumber
   FROM orderDetails od
   JOIN orders o
   USING (orderNumber)
   JOIN customers c
   USING (customerNumber)
   WHERE o.status = 'shipped' and YEAR(o.orderDate) = 2003
   GROUP BY c.customerNumber 
)
SELECT e.employeeNumber, CONCAT(e.firstName, e.lastName) as fullName, 
       e.email, e.officeCode, SUM(totalSales) as totalSales
FROM customerssales c
JOIN employees e
ON c.salesRepEmployeeNumber = e.employeeNumber
GROUP BY employeeNumber
ORDER BY totalSales DESC
LIMIT 5;

