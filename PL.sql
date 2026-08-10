-- Project Step 4 Draft
-- Team Members: Julie Glass & Abhijeet Singh
-- Group Number: 15
-- Project Title: Peak Apparel Co. Inventory Management System

-- This stored procedure is the full CUD Operation for Inventory
-- and OrderItems
-- It does functions like "CREATE" "UPDATE" and "DELETE".

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