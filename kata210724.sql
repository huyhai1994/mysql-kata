SHOW DATABASES;
CREATE DATABASE company;
USE company;


CREATE TABLE employees
(
    id         INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(50)    NOT NULL,
    department VARCHAR(50)    NOT NULL,
    salary     DECIMAL(10, 2) NOT NULL
);
SHOW COLUMNS FROM employees;
/*Bước 2: Tạo Trigger

Tiếp theo, chúng ta sẽ tạo một trigger để tự động cập nhật trường "department" của bảng "employees" khi thêm 1 bản ghi. Trigger này sẽ kiểm tra mức lương của nhân viên và cập nhật phòng ban tương ứng.*/

DELIMITER //

CREATE TRIGGER update_department
    BEFORE INSERT
    ON employees
    FOR EACH ROW
BEGIN
    IF new.salary >= 5000 THEN
        SET new.department = 'Management';
    ELSEIF new.salary >= 3000 THEN
        SET new.department = 'Sales';
    ELSE
        SET new.department = 'Support';
    END IF;
END //

DELIMITER ;

INSERT INTO employees (name, department, salary)
VALUES ('John Doe', 'A', 3500),
       ('Jane Smith', 'A', 2000),
       ('David Johnson', 'A', 6000);

SELECT *
FROM employees;

/*10. Tạo một trigger tên là cusUpdate trên bảng Customer, sao cho khi sửa mã khách (cID) thì mã khách trong bảng Order cũng được sửa theo: .	*/


USE product_management;
CALL get_customers();
SET AUTOCOMMIT = off;
COMMIT;
USE product_management;
UPDATE customers
SET id = 5
WHERE id = 1;
ROLLBACK;
CALL get_orders();

CREATE TRIGGER cusupdate
    AFTER UPDATE
    ON customers
    FOR EACH ROW
BEGIN
    UPDATE orders
    SET c_id = new.id
    WHERE c_id = old.id;
END;

/*Xoa trigger*/
DROP TRIGGER cusupdate;


/*10. Tạo một stored procedure tên là delProduct nhận vào 1 tham số là tên của một sản phẩm, strored procedure này sẽ xóa sản phẩm có tên được truyên vào thông qua tham số, và các thông tin liên quan đến sản phẩm đó ở trong bảng OrderDetail:	[2.5]
*/
COMMIT;
DELIMITER //
CREATE PROCEDURE del_product(IN product_name VARCHAR(25))
BEGIN
    DELETE
    FROM products
    WHERE name = product_name;

    DELETE
    FROM order_detail;
END //


CREATE TRIGGER cusupdate
    AFTER UPDATE
    ON customers
    FOR EACH ROW
BEGIN
    UPDATE orders
    SET c_id = new.id
    WHERE name = new.name;
END;
