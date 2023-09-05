-- 7 FUNCTIONS AND PROCEDURE EXERCISE

-- using database
USE 3_odds;

-- 1. Create a function that can determine the amount of bonus each sales representative gets! 
-- If the sales are more than 400,000 then get a bonus of 15,000, 
-- if the sales are in the range of 200,001 - 400,000 get a bonus of 10,000 
-- if the sales are in the range of 100,000-200,000 get a bonus of 5,000. 
-- Besides that, you don't get a bonus (0).

DELIMITER $$
CREATE FUNCTION sales_bonus(totalSales DECIMAL(10,2))
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE bonus DECIMAL (10,2);
	
    IF totalSales > 400000 THEN 
		SET bonus = 15000;
	ELSEIF totalSales > 200001 THEN
		SET bonus = 10000;
	ELSEIF totalSales > 100000 THEN
		SET bonus = 5000;
	ELSE
        SET bonus = 0;
	END IF;
	
    RETURN bonus;
END $$
DELIMITER ;

SELECT e.employeeNumber, CONCAT(e.firstName, ' ', e.lastName) as fullName, 
       e.officeCode, SUM(od.quantityOrdered * od.priceEach) as totalSales,
       sales_bonus(SUM(od.quantityOrdered * od.priceEach))as bonus
FROM orderDetails od
JOIN orders o
USING (orderNumber)
JOIN customers c
USING (customerNumber)
JOIN employees e
ON c.salesRepEmployeeNumber = e.employeeNumber
GROUP BY employeeNumber
ORDER BY totalSales DESC;


-- 2. Create a query to categorize customers based on the number of orders made! 
-- If the customer makes 1 order, it is categorized as a 'one-time customer'.
-- If the customer makes 2 orders, they are categorized as 'repeated customers'. 
-- If the customer makes 3 orders, they are categorized as a 'frequent customer'. 
-- If the customer makes more than 3 orders, they are categorized as a loyal customer.

DELIMITER $$
CREATE FUNCTION customer_categorization (orderFreq INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
	DECLARE category VARCHAR (50);
    IF orderFreq > 3 THEN
		SET category = "loyal customer";
	ELSEIF orderFreq = 3 THEN
		SET category = "frequent customer";
	ELSEIF orderFreq = 2 THEN
		SET category = "repeated customers";
	ELSEIF orderFreq = 1 THEN
		SET category = "one-time customer";
	ELSE
		SET category = 'unidentified';
	END IF;

	RETURN category;
END $$
DELIMITER ;

SELECT customerNumber, count(orderNumber) as orderFreq, 
       customer_categorization(count(orderNumber))
FROM orders
GROUP BY customerNumber
ORDER BY orderFreq DESC

-- 3. Create a procedure that can provide information on the 10 best-selling items sold in 2004!


-- 4. Create a query to count the number of orders sent (status = 'Shipped') and orders canceled (status = 'Cancelled')!
