USE classicmodels;
/*6. Reports those products that have been sold with a markup of 100% or more (i.e., the
priceEach is at least twice the buyPrice)*/

CALL get_ordersdetails();
CALL get_products();

SELECT DISTINCT productname,
                FORMAT(buyprice, 2),
                FORMAT(priceeach, 2)
FROM products p
         JOIN orderdetails od
              ON p.productcode = od.productcode
WHERE priceeach > 2 * buyprice;
/*7. List of the products ordered on monday*/

CALL get_products();
CALL get_orders();

SELECT DISTINCT (productname),
                orderdate,
                requireddate,
                shippeddate,
                status,
                comments,
                customernumber
FROM products p
         JOIN orderdetails od
              ON p.productcode = od.productcode
         JOIN orders o
              ON od.ordernumber = o.ordernumber
WHERE DAYNAME(orderdate) = 'MONDAY';

/*8. What is the quantity on hand for products listed on 'On Hold' orders?*/
CALL get_orders();
CALL get_ordersdetails();
CALL get_products();

/*Note
  1. quantity on hand/quantityInStock(products);
  2. 'On Hold' / status(orders);

  relationship: products -> orderdetails -> orders
  */
SELECT productname,
       FORMAT(quantityinstock, 0) AS 'quantity in stock',
       status
FROM products p
         JOIN orderdetails od
              ON p.productcode = od.productcode
         JOIN orders o
              ON od.ordernumber = o.ordernumber
WHERE status = 'ON HOLD';

/*<regular expression>*/
/*1. Find products containing the name 'Ford'.*/

/*Note:
  1. products info/ * (products)
  2. -> select products name = 'Ford';
  */
CALL get_products();
SELECT *
FROM products
WHERE productname REGEXP 'Ford';

/*same as*/
EXPLAIN
SELECT *
FROM products
WHERE productname LIKE '%ford%';

/*2. List products ending in 'ship'.*/
/*Cach 1*/
EXPLAIN
SELECT *
FROM products
WHERE productname LIKE '%ship';

/*Cach 2 */
SELECT *
FROM products
WHERE LOWER(productname) REGEXP 'ship$';

/*3. Report the number of customers in Denmark, Norway, and Sweden.*/
SELECT customername,
       CONCAT(contactlastname,
              contactfirstname) AS "
contact full name",
       city,
       state,
       postalcode,
       country
FROM customers
WHERE country REGEXP 'Denmark|Norway|Sweden'
ORDER BY country;

/*4. What are the products with a product code in the range S700_1000 to S700_1499?*/
/*Cach 1*/
SELECT *
FROM products
WHERE productcode BETWEEN 'S700_1000' AND 'S700_1499';
/*Cach 2*/
DELIMITER //
CREATE PROCEDURE get_productcodewithregexnumber()
BEGIN
    SELECT *
    FROM products
    WHERE
        productcode REGEXP 'S700_1[0-4][0-9]{2}';
END//
DELIMITER ;

CALL get_productcodewithregexnumber();
/*TODO: 5. Which customers have a digit in their name?*/
/*Cach 1*/
SELECT *
FROM customers
WHERE customername REGEXP
      '[0-9]';
/*Cach 2*/
SELECT *
FROM customers
WHERE customername REGEXP '[0-9]';

/*6. List the names of employees called Dianne or Diane.*/
SELECT *
FROM employees
WHERE employees.firstname REGEXP 'Dian';

/*7. List the products containing ship or boat in their product name.*/

SELECT *
FROM products
WHERE productname REGEXP 'boate|ship';

/*8. List the products with a product code beginning with S700.*/
SELECT *
FROM products
WHERE productcode REGEXP '^S700';

/*9. List the names of employees called Larry or Barry.*/
SELECT *
FROM employees
WHERE firstname REGEXP 'Larry|barry';

/*Cach 2 -> bi sai*/
SELECT *
FROM employees
WHERE firstname REGEXP '[BL]array';

/*10. List the names of employees with non-alphabetic characters in their names.*/
SELECT *
FROM employees
WHERE LOWER(firstname) REGEXP '[^a-z]';

/*11. List the vendors whose name ends in Diecast*/
SELECT DISTINCT(productvendor)
FROM products
WHERE LOWER(productvendor) REGEXP 'diecast$';

/*General queries*/
/*1. Who is at the top of the organization (i.e., reports to no one).*/
CALL get_employees();
SELECT *
FROM employees
WHERE reportsto IS NULL;

SHOW CREATE TABLE employees;
/*2. Who reports to William Patterson?*/
SELECT *
FROM employees e1
         JOIN employees e2
              ON e2.reportsto = e1.employeenumber
WHERE e1.firstname REGEXP 'William';
CALL get_employees();

/*Self join example*/
SELECT *
FROM employees boss
         JOIN employees reports
              ON boss.employeenumber =
                 reports.reportsto
WHERE boss.firstname = 'William'
  AND boss.lastname = 'Patterson';


