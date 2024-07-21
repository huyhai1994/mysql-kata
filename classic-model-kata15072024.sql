SHOW
    TABLES;

USE
    classicmodels;

SELECT c.customername,
       SUM(p.amount) AS customer_payment
FROM customers AS c
         LEFT JOIN payments AS p
                   ON c.customernumber =
                      p.customernumber
GROUP BY c.customername;

/*TODO: Solution 1: Displaying
        the year and the money paid*/
SELECT EXTRACT(YEAR FROM
               p.paymentdate) AS year,
       SUM(p.amount)          AS money_paid
FROM payments AS p
GROUP BY EXTRACT(YEAR FROM p.paymentdate);

SELECT EXTRACT(DAY FROM
               p.paymentdate) AS `day`,
       SUM(p.amount)          AS money_paid
FROM payments AS p
GROUP BY EXTRACT(DAY FROM p.paymentdate);

/*TODO: try to group by the customer payment
  and the day for each year*/
