-- Project Step 4 Draft
-- Team Members: Julie Glass & Abhijeet Singh
-- Group Number: 15
-- Project Title: Peak Apparel Co. Inventory Management System

-- This stored procedure is used for the Step 4 CUD operation.
-- It deletes one sample OrderItem so we can verify that the RESET procedure works.
-- After this row is deleted, clicking RESET should restore OrderItem 7005.

DROP PROCEDURE IF EXISTS sp_delete_order_item_7005;

DELIMITER //

CREATE PROCEDURE sp_delete_order_item_7005()
BEGIN
    DELETE FROM OrderItems
    WHERE order_item_id = 7005;
END //

DELIMITER ;