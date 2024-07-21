USE classicmodels;
SHOW TABLES;
/*TODO: 15. Which orders have a value greater than $5,000?*/
SELECT *
FROM orderdetails;

SELECT o.ordernumber,
       FORMAT(SUM(priceeach * quantityordered),
              2) AS 'value'
FROM orders o
         JOIN orderdetails od
              ON o.ordernumber = od.ordernumber
GROUP BY o.ordernumber
HAVING SUM(priceeach * quantityordered) > 5000;
/*Bai chua*/
SELECT ordernumber AS `Order number`,
       FORMAT(SUM(quantityordered * priceeach),
              2)   AS `Order value`
FROM orderdetails
GROUP BY ordernumber
HAVING SUM(quantityordered * priceeach) > 5000;
/*ONE TO MANY*/
/*TODO: 1. Report the account representative for each customer.*/

SELECT DISTINCT customername,
                CONCAT(e.lastname, ' ',
                       e.firstname) `employee_name`,
                jobtitle
FROM customers c
         JOIN employees e ON
    e.employeenumber = c.salesrepemployeenumber
WHERE jobtitle LIKE '%Sales%';

CALL get_employees;
/*TODO:2. Report total payments for Atelier graphique.*/
SELECT customername,
       SUM(amount) `total_payment`
FROM customers c
         JOIN payments p
              ON c.customernumber =
                 p.customernumber
WHERE customername LIKE '%Atelier%'
GROUP BY customername;

/*TODO: 3. Report the total payments by date*/
SELECT paymentdate,
       SUM(amount) `total_payment`
FROM payments
GROUP BY paymentdate;

/*TODO: 4. Report the products that have not been sold.*/

SELECT productname,
       od.quantityordered
FROM products p
         LEFT JOIN orderdetails od
                   ON p.productcode =
                      od.productcode;
/*Bai chua*/
SELECT productname, products.productcode
FROM products
WHERE NOT EXISTS (SELECT *
                  FROM orderdetails
                  WHERE orderdetails.productcode =
                        products.productcode);

SELECT *
FROM orders;

DELIMITER //
CREATE PROCEDURE get_orders()
BEGIN
    SELECT *
    FROM orders;
END//
CALL get_orders;

DELIMITER //
CREATE PROCEDURE get_customers()
BEGIN
    SELECT *
    FROM customers;
END//

DELIMITER  //
CREATE PROCEDURE get_ordersdetails()
BEGIN
    SELECT *
    FROM orderdetails;
END//
DELIMITER ;
CALL get_ordersdetails;

SHOW PROCEDURE STATUS;

DELIMITER //
CREATE PROCEDURE get_employees()
BEGIN
    SELECT * FROM employees;
END //
DELIMITER ;
CALL get_employees;

DELIMITER //
CREATE PROCEDURE get_payments()
BEGIN
    SELECT * FROM payments;
END //
DELIMITER ;
CALL get_payments;

DELIMITER //
CREATE PROCEDURE `get_officies`()
BEGIN
    SELECT * FROM offices;
END //
DELIMITER ;
CALL get_officies;

DELIMITER //
CREATE PROCEDURE `get_productlines`()
BEGIN
    SELECT * FROM productlines;
END //
DELIMITER ;
CALL get_productlines();


/*TODO: 5. List the amount paid by each customer.*/
CALL get_customers();
CALL get_payments();

SELECT customername,
       SUM(amount) AS 'amount_paid',
       SUM(amount) /
       (SELECT SUM(amount) FROM payments) *
       100         AS percentage
FROM customers
         JOIN payments
              ON customers.customernumber =
                 payments.customernumber
GROUP BY customername
ORDER BY percentage DESC
LIMIT 1;

/*TODO: 6. How many orders have been placed by Herkku Gifts?*/
CALL get_customers();
CALL get_orders();

SELECT customername,
       COUNT(o.ordernumber)
           'number_orders'
FROM customers c
         JOIN orders o
              ON c.customernumber =
                 o.customernumber
WHERE customername = 'Herkku Gifts'
GROUP BY customername;

SELECT COUNT(ordernumber)
FROM orders
         JOIN customers
              ON orders.customernumber =
                 customers.customernumber
                  AND
                 customername = 'Herkku Gifts';

/*TODO: 7. Who are the employees in Boston?*/
CALL get_officies();
CALL get_employees();

SELECT CONCAT(firstname, lastname) AS 'name',
       email,
       jobtitle,
       city
FROM employees AS e
         JOIN offices AS o
              ON e.officecode = o.officecode
WHERE city = 'boston';

SELECT firstname, lastname
FROM employees
         JOIN offices
              ON employees.officecode =
                 offices.officecode
                  AND city = 'Boston';
/*Check bai toi day 18 h 59p*/

/*TODO:8. Report those payments greater than $100,000. Sort the report so the customer who
made the highest payment appears first. */

CALL get_payments();
CALL get_customers();

SELECT DISTINCT customername,
                paymentdate,
                amount
FROM customers AS c
         JOIN payments AS p
WHERE amount > 100000
ORDER BY amount DESC;

/*TODO: 9. List the value of 'On Hold' orders.*/
CALL get_orders();
CALL get_ordersdetails();

SELECT o.customernumber,
       status,
       od.ordernumber,
       priceeach * quantityordered AS value
FROM orders o
         JOIN orderdetails od
              ON o.ordernumber = od.ordernumber
WHERE o.status = 'On Hold';
/*count product code number for each order number*/
SELECT orderdetails.ordernumber,
       COUNT(orderdetails.productcode) AS 'product_code_number'
FROM orderdetails
GROUP BY orderdetails.ordernumber
ORDER BY product_code_number DESC;

/*10. Report the number of orders 'On Hold' for each customer.*/

SELECT COUNT(o.status) AS 'number_orders'
FROM orders o
         JOIN orderdetails od
              ON o.ordernumber = od.ordernumber
WHERE o.status = 'On Hold';

/*TODO: 1. List products sold by order date.*/
EXPLAIN
SELECT productname,
       productline,
       orderdate
FROM products p
         JOIN orderdetails od
              ON p.productcode = od.productcode
         JOIN orders o
              ON od.ordernumber = o.ordernumber;

/*2. List the order dates in descending order for orders for the 1940 Ford Pickup Truck.*/

EXPLAIN
SELECT *
FROM (SELECT productname,
             productline,
             orderdate
      FROM products p
               JOIN orderdetails od
                    ON p.productcode =
                       od.productcode
               JOIN orders o
                    ON od.ordernumber =
                       o.ordernumber
      WHERE productname = '1940 Ford Pickup Truck'
      ORDER BY orderdate DESC) `ppo`;

/*3. List the names of customers and their corresponding order number where a
particular order from that customer has a value greater than $25,000?*/
CALL get_ordersdetails();
EXPLAIN
SELECT customername,
       od.ordernumber,
       o.orderdate,
       FORMAT(SUM(od.quantityordered *
                  od.priceeach), 2) AS "value[$]"
FROM customers c
         JOIN orders o
              ON c.customernumber =
                 o.customernumber
         JOIN orderdetails od
              ON o.ordernumber = od.ordernumber
GROUP BY o.ordernumber
HAVING SUM(od.quantityordered * od.priceeach)
           >
       25000
ORDER BY `value[$]` DESC;

/*4. Are there any products that appear on all orders?*/
SELECT *
FROM products
WHERE NOT EXISTS
          (SELECT *
           FROM orders
           WHERE NOT EXISTS
                     (SELECT *
                      FROM orderdetails
                      WHERE products.productcode =
                            orderdetails.productcode
                        AND orders.ordernumber =
                            orderdetails.ordernumber));
/*Loi giai nay chua hieu ro lam*/

/*5. List the names of products sold at less than 80% of the MSRP.*/
CALL get_products();
SELECT DISTINCT(productname), priceeach, msrp
FROM orderdetails
         JOIN products
              ON orderdetails.productcode =
                 products.productcode
                  AND priceeach < .8 * msrp;














