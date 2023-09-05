--  3rd MEET, BASIC QUERIES EXERCISE

-- using database
USE 3_odds;

-- 1. Show product information whose product line is not a Motorcycle nor Planes!
SELECT * 
FROM products
WHERE productLine NOT IN ('Motorcycles', 'Planes' )
ORDER BY productLine ASC;

-- 2. Show distinct value from the product_line column inside the products table!
SELECT DISTINCT productLine
FROM products;

-- 3. Calculate projected total sales for each product if all stock is sold out 
-- and the selling price is 10% greater than the MSRP!
SELECT productCode, productName, productLine, quantityInStock, MSRP, (quantityInStock * (MSRP*(1+0.1))) as totalSales
FROM products
ORDER BY totalSales DESC;

-- 4. Show product data whose name contains the word ship or motto!
SELECT *
FROM products
WHERE productName LIKE '%ship%' OR productName LIKE '%moto%';

-- 5. Show the 3 cheapest products (by MSRP) from the product line consisting of classic cars and vintage cars!
SELECT *
FROM products
WHERE productLine IN ('Classic Cars','Vintage Cars')
ORDER BY MSRP ASC
LIMIT 3;

-- 6. If the company follows the selling price recommended by the product vendor, 
--    show 10 products that will generate the most profit for the company! 
--    For this case profit = revenue - selling price of the product

-- the most profit for single item
SELECT productName, productLine, productVendor, buyPrice, MSRP,
       MSRP - buyPrice as profit
FROM products
ORDER BY profit DESC
LIMIT 10;

-- the most profit if all quantity in stock are sold
SELECT productName, productLine, productVendor, buyPrice, MSRP, quantityInStock,
	   quantityInStock * buyPrice as total_cost, 
       quantityInStock * MSRP as total_revenue,
       (quantityInStock * MSRP) - (quantityInStock * buyPrice) as total_profit
FROM products
ORDER BY total_profit DESC
LIMIT 10;
