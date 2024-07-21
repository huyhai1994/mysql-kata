USE classicmodels;
/*2. Which payments in any month and year are more than twice the average for that
month and year (i.e. compare all payments in Oct 2004 with the average payment for
Oct 2004)? Order the results by the date of the payment. You will need to use the date
functions.*/

DELIMITER //

/*Average payments of 10/2024*/
SELECT AVG(amount)
FROM payments
WHERE YEAR(paymentdate) = 2004
  AND MONTH(paymentdate) = 10;

SELECT *,
       (SELECT AVG(amount)
        FROM payments
        WHERE YEAR(paymentdate) = 2004
          AND MONTH(paymentdate) = 10) AS "avage amount"
FROM payments
WHERE YEAR(paymentdate) = 2004
  AND MONTH(paymentdate) = 10
  AND amount > 2 * (SELECT AVG(amount)
                    FROM payments
                    WHERE YEAR(paymentdate) = 2004
                      AND MONTH(paymentdate) = 10);

SET @year = 2003;
SET @month = 10;

SELECT *,
       (SELECT AVG(amount)
        FROM payments
        WHERE YEAR(paymentdate) = @year
          AND MONTH(paymentdate) = @month) AS "average_amount"
FROM payments
WHERE YEAR(paymentdate) = @year
  AND MONTH(paymentdate) = @month
  AND amount > 2 * (SELECT AVG(amount)
                    FROM payments
                    WHERE YEAR(paymentdate) = @year
                      AND MONTH(paymentdate) = @month);