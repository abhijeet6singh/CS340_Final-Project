-- Project Step 4 Draft
-- Team Members: Julie Glass & Abhijeet Singh
-- Group Number: 15
-- Project Title: Peak Apparel Co. Inventory Management System

DROP PROCEDURE IF EXISTS sp_delete_demo_item;

DELIMITER //

CREATE PROCEDURE sp_delete_demo_item(IN p_inventory_id INT)
BEGIN
    DELETE FROM Inventory
    WHERE inventory_id = p_inventory_id;
END //

DELIMITER ;