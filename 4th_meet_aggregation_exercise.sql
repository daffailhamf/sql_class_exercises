-- 4th MEET, AGGREGATION EXERCISE

-- using database
USE 3_odds;

-- 1. Present information about the total, average, and maximum credit limit from the customer table!
SELECT SUM(creditLimit) as totalCreditLimit,
	   AVG(creditLimit) as averageCreditLimit,
       MAX(creditLimit) as maxCreditLimit
FROM customers;

-- 2. Which cities have customers with 0 credit limits, and how many customers do they have?
SELECT city, COUNT(creditLimit) as custCount
FROM customers
WHERE creditLimit = 0
GROUP BY city
ORDER BY custCount DESC;

-- 3. How many customers have a credit limit above the average?
SELECT COUNT(creditLimit) as custCount
FROM customers
WHERE creditLimit > (SELECT AVG(creditLimit) FROM customers);

-- 4. Present information regarding the date when the customer made their first payment!
SELECT p.customerNumber, MIN(p.paymentDate) as firstPayment,
	   (SELECT amount
        FROM payments
        WHERE customerNumber = p.customerNumber AND paymentDate = MIN(p.paymentDate)
	   ) as amount
FROM payments p
GROUP BY p.customerNumber
ORDER BY MIN(p.paymentDate) ASC;

-- 5. Show 3 customers who have made the most transactions!

-- the most frequent payment
SELECT customerNumber, COUNT(customerNumber) as paymentFrequency
FROM payments
GROUP BY customerNumber
ORDER BY paymentFrequency DESC
LIMIT 3;

-- the most amount
SELECT customerNumber, SUM(amount) as amount
FROM payments
GROUP BY customerNumber
ORDER BY amount DESC
LIMIT 3;

-- the most frequent order
SELECT customerNumber, COUNT(orderNumber) as orderFrequency
FROM orders
GROUP BY customerNumber
ORDER BY orderFrequency DESC
LIMIT 3;

-- 6. What is the average credit limit of customers from cities in Germany and France?
SELECT city, country, AVG(creditLimit) as avgCreditLimit
FROM customers
WHERE country IN ('Germany', 'France')
GROUP BY city, country
ORDER BY avgCreditLimit DESC;

-- 7. Present information on 3 countries that have the highest percentage of customers!
SELECT country, 
	   (COUNT(customerNumber) / (SELECT COUNT(customerNumber) FROM customers)) * 100 as custPercent
FROM customers
GROUP BY country
ORDER BY custPercent DESC
LIMIT 3;
