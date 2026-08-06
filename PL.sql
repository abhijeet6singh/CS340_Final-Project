-- Project Step 4 Draft
-- Team Members: Julie Glass & Abhijeet Singh
-- Group Number: 15
-- Project Title: Peak Apparel Co. Inventory Management System

-- This stored procedure is the one CUD operation for Step 4.
-- It deletes one sample inventory item so RESET can be verified.
-- RESET restores the original sample data.

DROP PROCEDURE IF EXISTS sp_delete_demo_item;

DELIMITER //

CREATE PROCEDURE sp_delete_demo_item()
BEGIN
    DELETE FROM Inventory
    WHERE inventory_id = 104;
END //

DELIMITER ;