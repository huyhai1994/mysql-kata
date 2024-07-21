USE classicmodels;
/*TODO: 1. Prepare a list of offices sorted by country, state, city.*/
SHOW TABLES;
SELECT officecode,
       city,
       phone,
       state,
       country
FROM offices AS o
ORDER BY country, city, state;

/*TODO: How many employees are there in the company?
  */
SELECT COUNT(*) AS 'employees number'
FROM employees;
/*TODO:3. What is the total of payments received? */
SELECT COUNT(*) AS 'payment number'
FROM payments;

SELECT *
FROM payments;

/*TODO:List the product lines that contain 'Cars'.*/
SELECT *
FROM productlines;

SELECT *
FROM productlines AS pl
WHERE pl.productline LIKE '%cars%';


/*TODO: 5. Report total payments for October 28, 2004.*/
SELECT *
FROM payments;

SELECT customernumber,
       paymentdate,
       amount
FROM payments
WHERE paymentdate = '2004-10-28';

/*TODO: 6. Report those payments greater than $100,000.*/
SELECT *
FROM payments AS p
WHERE p.amount > 100000;

/*TODO: 8. How many products in each product line?*/
SELECT products.productline,
       COUNT(productname) AS 'numberproducts'
FROM productlines
         JOIN products
              ON products.productline =
                 productlines.productline
GROUP BY (products.productline)
ORDER BY numberproducts;
/*TODO: 9. What is the minimum payment received?*/
SELECT MIN(payments.amount)
FROM payments;

/*TODO: 10. List all payments greater than twice the average payment.*/
SELECT *
FROM payments;

SELECT p.customernumber, p.amount
FROM payments AS p
WHERE p.amount >
      2 *
      (SELECT AVG(amount) AS avg FROM payments);

SELECT AVG(amount)
FROM payments;

/*TODO: 11. What is the average percentage markup of the MSRP on buyPrice?*/
SELECT *
FROM products;

SELECT AVG(products.msrp * products.buyprice /
           100) AS 'percent'
FROM products;

/*TODO: 12. How many distinct products does ClassicModels sell?*/
SELECT COUNT(DISTINCT productname)
FROM products;

/*TODO: 13. Report the name and city of customers who don't have sales representatives?*/

SELECT *
FROM customers;

SELECT customername,
       city
FROM customers
WHERE salesrepemployeenumber IS NULL;
/*TODO: 14. What are the names of executives with VP or Manager in their title? Use the CONCAT
function to combine the employee's first name and last name into a single field for
reporting.*/
SELECT *
FROM employees;

SELECT CONCAT(employees.firstname, ' ',
              employees.lastname) AS 'name'
FROM employees
WHERE jobtitle LIKE '%VP%'
   OR '%Manager'
/*TODO: 15. Which orders have a value greater than $5,000?*/
SELECT *
FROM orders;

select * FROM orders
WHERE orders.