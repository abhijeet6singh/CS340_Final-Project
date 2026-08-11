-- Project Step 5 Final
-- Team Members: Julie Glass & Abhijeet Singh
-- Group Number: 15
-- Project Title: Peak Apparel Co. Inventory Management System

-- This file contains procedures for Inventory and OrderItems CUD Operations.
-- It contains procedures like "CREATE" "UPDATE" and "DELETE".

-- ============================================================
-- CREATE Inventory
-- ============================================================

DROP PROCEDURE IF EXISTS sp_create_inventory;

DELIMITER //

CREATE PROCEDURE sp_create_inventory(
    IN p_sku VARCHAR(50),
    IN p_inventory_type VARCHAR(50),
    IN p_brand_name VARCHAR(50),
    IN p_distributor_id INT,
    IN p_retail_price DECIMAL(10,2),
    IN p_quantity_in_stock INT
)
COMMENT 'Creates a new inventory item.'
BEGIN
    INSERT INTO Inventory (
        sku,
        inventory_type,
        brand_name,
        distributor_id,
        retail_price,
        quantity_in_stock
    )
    VALUES (
        p_sku,
        p_inventory_type,
        p_brand_name,
        p_distributor_id,
        p_retail_price,
        p_quantity_in_stock
    );
END //

DELIMITER ;


-- ============================================================
-- UPDATE Inventory
-- ============================================================

DROP PROCEDURE IF EXISTS sp_update_inventory;

DELIMITER //

CREATE PROCEDURE sp_update_inventory(
    IN p_inventory_id INT,
    IN p_sku VARCHAR(50),
    IN p_inventory_type VARCHAR(50),
    IN p_brand_name VARCHAR(50),
    IN p_distributor_id INT,
    IN p_retail_price DECIMAL(10,2),
    IN p_quantity_in_stock INT
)
COMMENT 'Updates an existing inventory item.'
BEGIN
    UPDATE Inventory
    SET sku = p_sku,
        inventory_type = p_inventory_type,
        brand_name = p_brand_name,
        distributor_id = p_distributor_id,
        retail_price = p_retail_price,
        quantity_in_stock = p_quantity_in_stock
    WHERE inventory_id = p_inventory_id;
END //

DELIMITER ;


-- ============================================================
-- DELETE Inventory
-- ============================================================

DROP PROCEDURE IF EXISTS sp_delete_inventory;

DELIMITER //

CREATE PROCEDURE sp_delete_inventory(IN p_inventory_id INT)
COMMENT 'Deletes a selected inventory item by inventory_id.'
BEGIN
    DELETE FROM Inventory
    WHERE inventory_id = p_inventory_id;
END //

DELIMITER ;


-- ============================================================
-- CREATE OrderItem
-- ============================================================

DROP PROCEDURE IF EXISTS sp_create_orderitem;

DELIMITER //

CREATE PROCEDURE sp_create_orderitem(
    IN p_order_id INT,
    IN p_inventory_id INT,
    IN p_quantity INT,
    IN p_discount_percent DECIMAL(5,2),
    IN p_selling_price DECIMAL(10,2),
    IN p_shipped TINYINT,
    IN p_shipping_date DATE
)
COMMENT 'Creates a new row in the OrderItems M:N relationship.'
BEGIN
    INSERT INTO OrderItems (
        order_id,
        inventory_id,
        quantity,
        discount_percent,
        selling_price,
        shipped,
        shipping_date
    )
    VALUES (
        p_order_id,
        p_inventory_id,
        p_quantity,
        p_discount_percent,
        p_selling_price,
        p_shipped,
        p_shipping_date
    );
END //

DELIMITER ;


-- ============================================================
-- UPDATE OrderItem M:N
-- ============================================================

DROP PROCEDURE IF EXISTS sp_update_orderitem;

DELIMITER //

CREATE PROCEDURE sp_update_orderitem(
    IN p_order_item_id INT,
    IN p_inventory_id INT,
    IN p_quantity INT,
    IN p_discount_percent DECIMAL(5,2),
    IN p_selling_price DECIMAL(10,2),
    IN p_shipped TINYINT,
    IN p_shipping_date DATE
)
COMMENT 'Updates an OrderItems row, including inventory_id for the M:N relationship.'
BEGIN
    UPDATE OrderItems
    SET inventory_id = p_inventory_id,
        quantity = p_quantity,
        discount_percent = p_discount_percent,
        selling_price = p_selling_price,
        shipped = p_shipped,
        shipping_date = p_shipping_date
    WHERE order_item_id = p_order_item_id;
END //

DELIMITER ;


-- ============================================================
-- DELETE OrderItem M:N
-- ============================================================

DROP PROCEDURE IF EXISTS sp_delete_orderitem;

DELIMITER //

CREATE PROCEDURE sp_delete_orderitem(IN p_order_item_id INT)
COMMENT 'Deletes one OrderItems row from the Orders-Inventory M:N relationship.'
BEGIN
    DELETE FROM OrderItems
    WHERE order_item_id = p_order_item_id;
END //

DELIMITER ;

-- ============================================================
-- CREATE Customer
-- ============================================================

DROP PROCEDURE IF EXISTS sp_create_customer;

DELIMITER //

CREATE PROCEDURE sp_create_customer(
    IN p_customer_first_name VARCHAR(50),
    IN p_customer_last_name VARCHAR(50),
    IN p_customer_street VARCHAR(100),
    IN p_customer_city VARCHAR(50),
    IN p_customer_state CHAR(2),
    IN p_customer_zip VARCHAR(10),
    IN p_customer_phone VARCHAR(20),
    IN p_customer_email VARCHAR(100)
)
COMMENT 'Creates a new customer.'
BEGIN
    INSERT INTO Customers (
        customer_first_name,
        customer_last_name,
        customer_street,
        customer_city,
        customer_state,
        customer_zip,
        customer_phone,
        customer_email
    )
    VALUES (
        p_customer_first_name,
        p_customer_last_name,
        p_customer_street,
        p_customer_city,
        p_customer_state,
        p_customer_zip,
        p_customer_phone,
        p_customer_email
    );
END //

DELIMITER ;


-- ============================================================
-- UPDATE Customer
-- ============================================================

DROP PROCEDURE IF EXISTS sp_update_customer;

DELIMITER //

CREATE PROCEDURE sp_update_customer(
    IN p_customer_id INT,
    IN p_customer_first_name VARCHAR(50),
    IN p_customer_last_name VARCHAR(50),
    IN p_customer_street VARCHAR(100),
    IN p_customer_city VARCHAR(50),
    IN p_customer_state CHAR(2),
    IN p_customer_zip VARCHAR(10),
    IN p_customer_phone VARCHAR(20),
    IN p_customer_email VARCHAR(100)
)
COMMENT 'Updates an existing customer.'
BEGIN
    UPDATE Customers
    SET customer_first_name = p_customer_first_name,
        customer_last_name = p_customer_last_name,
        customer_street = p_customer_street,
        customer_city = p_customer_city,
        customer_state = p_customer_state,
        customer_zip = p_customer_zip,
        customer_phone = p_customer_phone,
        customer_email = p_customer_email
    WHERE customer_id = p_customer_id;
END //

DELIMITER ;


-- ============================================================
-- DELETE Customer
-- ============================================================

DROP PROCEDURE IF EXISTS sp_delete_customer;

DELIMITER //

CREATE PROCEDURE sp_delete_customer(IN p_customer_id INT)
COMMENT 'Deletes a customer and related order records.'
BEGIN
    DELETE FROM OrderItems
    WHERE order_id IN (
        SELECT order_id
        FROM Orders
        WHERE customer_id = p_customer_id
    );

    DELETE FROM Orders
    WHERE customer_id = p_customer_id;

    DELETE FROM Customers
    WHERE customer_id = p_customer_id;
END //

DELIMITER ;

-- -----------------------------------------------------
-- CREATE Distributor
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS sp_create_distributor;

DELIMITER //

CREATE PROCEDURE sp_create_distributor(
    IN p_distributor_name VARCHAR(100),
    IN p_distributor_street VARCHAR(100),
    IN p_distributor_city VARCHAR(50),
    IN p_distributor_state CHAR(2),
    IN p_distributor_zip VARCHAR(10),
    IN p_distributor_phone VARCHAR(20),
    IN p_distributor_contact_person VARCHAR(100)
)
COMMENT 'Creates a new distributor.'
BEGIN
    INSERT INTO Distributors (
        distributor_name,
        distributor_street,
        distributor_city,
        distributor_state,
        distributor_zip,
        distributor_phone,
        distributor_contact_person
    )
    VALUES (
        p_distributor_name,
        p_distributor_street,
        p_distributor_city,
        p_distributor_state,
        p_distributor_zip,
        p_distributor_phone,
        p_distributor_contact_person
    );
END //

DELIMITER ;


-- -----------------------------------------------------
-- UPDATE Distributor
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS sp_update_distributor;

DELIMITER //

CREATE PROCEDURE sp_update_distributor(
    IN p_distributor_id INT,
    IN p_distributor_name VARCHAR(100),
    IN p_distributor_street VARCHAR(100),
    IN p_distributor_city VARCHAR(50),
    IN p_distributor_state CHAR(2),
    IN p_distributor_zip VARCHAR(10),
    IN p_distributor_phone VARCHAR(20),
    IN p_distributor_contact_person VARCHAR(100)
)
COMMENT 'Updates an existing distributor.'
BEGIN
    UPDATE Distributors
    SET distributor_name = p_distributor_name,
        distributor_street = p_distributor_street,
        distributor_city = p_distributor_city,
        distributor_state = p_distributor_state,
        distributor_zip = p_distributor_zip,
        distributor_phone = p_distributor_phone,
        distributor_contact_person = p_distributor_contact_person
    WHERE distributor_id = p_distributor_id;
END //

DELIMITER ;


-- -----------------------------------------------------
-- DELETE Distributor
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS sp_delete_distributor;

DELIMITER //

CREATE PROCEDURE sp_delete_distributor(IN p_distributor_id INT)
COMMENT 'Deletes a distributor and related purchase records.'
BEGIN
    DELETE FROM PurchaseItems
    WHERE purchase_id IN (
        SELECT purchase_id
        FROM Purchases
        WHERE distributor_id = p_distributor_id
    );

    DELETE FROM Purchases
    WHERE distributor_id = p_distributor_id;

    DELETE FROM Distributors
    WHERE distributor_id = p_distributor_id;
END //

DELIMITER ;

-- -----------------------------------------------------
-- CREATE Order
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS sp_create_order;

DELIMITER //

CREATE PROCEDURE sp_create_order(
    IN p_customer_id INT,
    IN p_order_date DATE,
    IN p_payment_method VARCHAR(50),
    IN p_payment_last_four CHAR(4),
    IN p_order_complete TINYINT,
    IN p_pickup_or_ship VARCHAR(20)
)
COMMENT 'Creates a new customer order.'
BEGIN
    INSERT INTO Orders (
        customer_id,
        order_date,
        payment_method,
        payment_last_four,
        order_complete,
        pickup_or_ship
    )
    VALUES (
        p_customer_id,
        p_order_date,
        p_payment_method,
        p_payment_last_four,
        p_order_complete,
        p_pickup_or_ship
    );
END //

DELIMITER ;


-- -----------------------------------------------------
-- UPDATE Order
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS sp_update_order;

DELIMITER //

CREATE PROCEDURE sp_update_order(
    IN p_order_id INT,
    IN p_order_complete TINYINT,
    IN p_pickup_or_ship VARCHAR(20)
)
COMMENT 'Updates order status and pickup or shipping choice.'
BEGIN
    UPDATE Orders
    SET order_complete = p_order_complete,
        pickup_or_ship = p_pickup_or_ship
    WHERE order_id = p_order_id;
END //

DELIMITER ;


-- -----------------------------------------------------
-- DELETE Order
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS sp_delete_order;

DELIMITER //

CREATE PROCEDURE sp_delete_order(IN p_order_id INT)
COMMENT 'Deletes an order and its order item rows.'
BEGIN
    DELETE FROM OrderItems
    WHERE order_id = p_order_id;

    DELETE FROM Orders
    WHERE order_id = p_order_id;
END //

DELIMITER ;