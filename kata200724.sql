/*Tao database de thao tac*/
SHOW DATABASES;
CREATE DATABASE product_management;
USE product_management;
SHOW TABLES;
/**/
CREATE TABLE customers
(
    id   INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(25),
    age  TINYINT
);

SHOW COLUMNS FROM customers;
INSERT INTO customers (name, age)
VALUES ('Minh Quan', 10),
       ('Ngoc Oanh', 20),
       ('Hong Ha', 50);
SELECT *
FROM customers;

CREATE TABLE orders
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    cid        INT,
    date       DATETIME,
    totalprice INT,
    FOREIGN KEY (cid) REFERENCES customers (id)
);

CREATE TABLE products
(
    id    INT PRIMARY KEY AUTO_INCREMENT,
    name  VARCHAR(25),
    price INT
);

CREATE TABLE order_detail
(
    o_id        INT,
    p_id        INT,
    od_quantity INT,
    FOREIGN KEY (o_id) REFERENCES orders (id),
    FOREIGN KEY (p_id) REFERENCES products (id)
);
ALTER TABLE orders RENAME COLUMN cid TO c_id;
/*Create tables end*/
INSERT INTO orders(c_id, date, totalprice)
VALUES (1, '2006-03-21', NULL),
       (2, '2006-03-23', NULL),
       (1, '2006-03-16', NULL);
SELECT *
FROM orders;

SELECT name,
       age,
       o.id,
       c_id,
       date,
       totalprice
FROM customers c
         LEFT JOIN orders o
                   ON c.id = o.c_id

INSERT INTO products(name, price)
VALUES ('May Giat', 3),
       ('Tu Lanh', 5),
       ('Dieu Hoa', 7),
       ('Quat', 1),
       ('Bep Dien', 2);
SELECT *
FROM products;

INSERT INTO order_detail
VALUES (1, 1, 3),
       (1, 3, 7),
       (1, 4, 2),
       (2, 1, 1),
       (3, 1, 8),
       (2, 5, 4),
       (2, 3, 3);
/*Insert data -> table end*/

/*create procedures*/
DELIMITER //
CREATE PROCEDURE get_orders()
BEGIN
    SELECT * FROM orders;
END //
DELIMITER ;
CALL get_orders();

DELIMITER //
CREATE PROCEDURE get_customers()
BEGIN
    SELECT * FROM customers;
END //
DELIMITER ;
CALL get_customers;

DELIMITER //
CREATE PROCEDURE get_products()
BEGIN
    SELECT * FROM products;
END //
DELIMITER ;

/*create procedures end*/

/*2. Hiển thị các thông tin  gồm oID, oDate, oPrice của tất cả các hóa đơn trong bảng Order, danh sách phải sắp xếp theo thứ tự ngày tháng, hóa đơn mới hơn nằm trên như hình sau:*/

SELECT *
FROM orders o
ORDER BY date
        DESC;

/*3. Hiển thị tên và giá của các sản phẩm có giá cao nhất như sau:*/

SELECT name, price
FROM products
WHERE price = (SELECT MAX(price)
               FROM products);

/*4. Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách đó như sau:*/
CALL get_customers;
CALL get_products();

SELECT c.name,
       p.name
FROM customers c
         JOIN orders o
              ON c.id = o.c_id
         JOIN order_detail od
              ON o.id = od.o_id
         JOIN products p
              ON od.p_id = p.id;

/*5. Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào như sau:*/


SELECT c.name,
       p.name
FROM customers c
         LEFT JOIN orders o
                   ON c.id = o.c_id
         LEFT JOIN order_detail od
                   ON o.id = od.o_id
         LEFT JOIN products p
                   ON od.p_id = p.id
WHERE p.name IS NULL;


/*6. Hiển thị chi tiết của từng hóa đơnnhư sau :*/
SELECT o.id,
       date,
       od_quantity,
       name,
       price
FROM orders o
         JOIN order_detail od ON o.id = od.o_id
         JOIN products p ON od.p_id = p.id

/*7. Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn (giá một hóa đơn được tính bằng tổng giá bán của từng loại mặt hàng xuất hiện trong hóa đơn. Giá bán của từng loại được tính = odQTY*pPrice) như sau:*/

SELECT o.id,
       date,
       SUM(price * od_quantity)
FROM orders o
         JOIN order_detail od ON o.id = od.o_id
         JOIN products p ON od.p_id = p.id
GROUP BY o.id;
/*8.Tạo một view tên là Sales để hiển thị tổng doanh thu của siêu thị như sau:	*/
CREATE VIEW sales AS
SELECT SUM(price * od_quantity)
FROM orders o
         JOIN order_detail od ON o.id = od.o_id
         JOIN products p ON od.p_id = p.id;
/*Xóa tất cả các ràng buộc khóa ngoại, khóa chính của tất cả các bảng.*/
ALTER TABLE orders
    ADD COLUMN orders_ibfk_1 INT;

ALTER TABLE orders
    ADD FOREIGN KEY (orders_ibfk_1)
        REFERENCES customers (id);

SHOW CREATE TABLE orders;

SET AUTOCOMMIT = off;
COMMIT;
DELETE
FROM products;

DELETE
FROM customers;
CALL get_customers();
ALTER TABLE orders
    DROP FOREIGN KEY orders_ibfk_1;

ROLLBACK;
/*
    trigger là một đối tượng cơ sở dữ liệu được sử dụng để kích hoạt một hành động tự động (hoặc một tập hợp các hành động) khi có sự thay đổi dữ liệu xảy ra trong bảng hoặc các sự kiện khác xảy ra trong CSDL. Trigger có thể được sử dụng để kiểm tra, thay đổi hoặc bổ sung dữ liệu dựa trên các điều kiện và quy tắc được định nghĩa trước.
    Khi một sự kiện được kích hoạt (ví dụ: INSERT, UPDATE, DELETE) trong bảng liên quan đến trigger, MySQL sẽ thực thi trigger và thực hiện các hành động được định nghĩa trong trigger đó.

Trigger thường được sử dụng để:

    Kiểm tra và xử lý các giá trị dữ liệu trước hoặc sau khi chúng được chèn, cập nhật hoặc xóa trong bảng.
    Tự động thực hiện các hành động phụ thuộc vào các sự kiện xảy ra trong CSDL, ví dụ như ghi log, cập nhật các bảng phụ, gửi thông báo, v.v.
    Hạn chế, kiểm tra tính hợp lệ hoặc áp dụng các quy tắc kinh doanh trước khi thay đổi dữ liệu trong bảng.
*/


CREATE TRIGGER del_order
    CREATE TRIGGER cusupdate
        AFTER UPDATE
        ON customers
        FOR EACH ROW
    BEGIN
        UPDATE orders;
    END//












