-- Project Step 5 Final
-- Group 15
-- Julie Glass and Abhijeet Singh
-- Peak Apparel Co. Inventory Management System

-- This file has the SQL queries that will be used later by the website.


-- -----------------------------------------------------
-- Customers
-- -----------------------------------------------------

SELECT customer_id, customer_first_name, customer_last_name, customer_street,
       customer_city, customer_state, customer_zip, customer_phone, customer_email
FROM Customers;

-- add a new customer after they make an order or create a customer profile
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
    @firstName,
    @lastName,
    @street,
    @city,
    @state,
    @zip,
    @phone,
    @email
);

-- update a customer's information if their contact details or address changes
UPDATE Customers
SET customer_first_name = @firstName,
    customer_last_name = @lastName,
    customer_street = @street,
    customer_city = @city,
    customer_state = @state,
    customer_zip = @zip,
    customer_phone = @phone,
    customer_email = @email
WHERE customer_id = @customerID;

-- delete a customer record if it was entered by mistake or is no longer needed
DELETE FROM Customers
WHERE customer_id = @customerID;


-- -----------------------------------------------------
-- Distributors
-- -----------------------------------------------------

SELECT distributor_id, distributor_name, distributor_street, distributor_city,
       distributor_state, distributor_zip, distributor_phone,
       distributor_contact_person
FROM Distributors;

-- add a new distributor when Peak Apparel starts ordering from a new supplier
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
    @distributorName,
    @street,
    @city,
    @state,
    @zip,
    @phone,
    @contactPerson
);

-- update distributor information if the supplier changes address, phone, or contact person
UPDATE Distributors
SET distributor_name = @distributorName,
    distributor_street = @street,
    distributor_city = @city,
    distributor_state = @state,
    distributor_zip = @zip,
    distributor_phone = @phone,
    distributor_contact_person = @contactPerson
WHERE distributor_id = @distributorID;

-- delete a distributor if it was added by mistake or is no longer used
DELETE FROM Distributors
WHERE distributor_id = @distributorID;


-- -----------------------------------------------------
-- Inventory
-- -----------------------------------------------------

SELECT Inventory.inventory_id, Inventory.sku, Inventory.inventory_type,
       Inventory.brand_name, Inventory.distributor_id,
       Distributors.distributor_name, Inventory.retail_price,
       Inventory.quantity_in_stock
FROM Inventory
INNER JOIN Distributors
    ON Inventory.distributor_id = Distributors.distributor_id;

-- get distributor options for the inventory add and update forms
SELECT distributor_id, distributor_name
FROM Distributors;

-- add a new inventory item when the store starts carrying a new product
INSERT INTO Inventory (
    sku,
    inventory_type,
    brand_name,
    distributor_id,
    retail_price,
    quantity_in_stock
)
VALUES (
    @sku,
    @inventoryType,
    @brandName,
    @distributorID,
    @retailPrice,
    @quantityInStock
);

-- update an inventory item if the price, stock amount, brand, type, or distributor changes
UPDATE Inventory
SET sku = @sku,
    inventory_type = @inventoryType,
    brand_name = @brandName,
    distributor_id = @distributorID,
    retail_price = @retailPrice,
    quantity_in_stock = @quantityInStock
WHERE inventory_id = @inventoryID;

-- delete an inventory item if it was entered by mistake or is no longer sold
DELETE FROM Inventory
WHERE inventory_id = @inventoryID;


-- -----------------------------------------------------
-- Orders
-- -----------------------------------------------------

SELECT Orders.order_id, Orders.customer_id, Customers.customer_first_name,
       Customers.customer_last_name, Orders.order_date, Orders.payment_method,
       Orders.payment_last_four, Orders.order_complete, Orders.pickup_or_ship
FROM Orders
INNER JOIN Customers
    ON Orders.customer_id = Customers.customer_id;

-- get customer options for the order add and update forms
SELECT customer_id, customer_first_name, customer_last_name
FROM Customers;

-- add a new order when a customer buys items from the store
INSERT INTO Orders (
    customer_id,
    order_date,
    payment_method,
    payment_last_four,
    order_complete,
    pickup_or_ship
)
VALUES (
    @customerID,
    @orderDate,
    @paymentMethod,
    @paymentLastFour,
    @orderComplete,
    @pickupOrShip
);

-- update an order if the payment method, order status, customer, or pickup/shipping choice changes
UPDATE Orders
SET customer_id = @customerID,
    order_date = @orderDate,
    payment_method = @paymentMethod,
    payment_last_four = @paymentLastFour,
    order_complete = @orderComplete,
    pickup_or_ship = @pickupOrShip
WHERE order_id = @orderID;

-- delete an order if it was entered by mistake or needs to be removed
DELETE FROM Orders
WHERE order_id = @orderID;


-- -----------------------------------------------------
-- OrderItems
-- -----------------------------------------------------

SELECT OrderItems.order_item_id, OrderItems.order_id,
       OrderItems.inventory_id, Inventory.sku, Inventory.inventory_type,
       Inventory.brand_name, OrderItems.quantity,
       OrderItems.discount_percent, OrderItems.selling_price,
       OrderItems.shipped, OrderItems.shipping_date
FROM OrderItems
INNER JOIN Orders
    ON OrderItems.order_id = Orders.order_id
INNER JOIN Inventory
    ON OrderItems.inventory_id = Inventory.inventory_id;

SELECT order_id, customer_id, order_date
FROM Orders;

-- get inventory options for the order item add and update forms
SELECT inventory_id, sku, inventory_type, brand_name
FROM Inventory;

-- add an item to an order after a customer chooses a product to buy
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
    @orderID,
    @inventoryID,
    @quantity,
    @discountPercent,
    @sellingPrice,
    @shipped,
    @shippingDate
);

-- update an order item if the quantity, discount, selling price, or shipping information changes
UPDATE OrderItems
SET order_id = @orderID,
    inventory_id = @inventoryID,
    quantity = @quantity,
    discount_percent = @discountPercent,
    selling_price = @sellingPrice,
    shipped = @shipped,
    shipping_date = @shippingDate
WHERE order_item_id = @orderItemID;

-- delete an order item if it was added to the wrong order or should be removed
DELETE FROM OrderItems
WHERE order_item_id = @orderItemID;


-- -----------------------------------------------------
-- Purchases
-- -----------------------------------------------------

SELECT Purchases.purchase_id, Purchases.purchase_date,
       Purchases.distributor_id, Distributors.distributor_name
FROM Purchases
INNER JOIN Distributors
    ON Purchases.distributor_id = Distributors.distributor_id;

SELECT distributor_id, distributor_name
FROM Distributors;

-- add a new purchase when the store buys inventory from a distributor
INSERT INTO Purchases (
    purchase_date,
    distributor_id
)
VALUES (
    @purchaseDate,
    @distributorID
);

-- update a purchase if the purchase date or distributor needs to be corrected
UPDATE Purchases
SET purchase_date = @purchaseDate,
    distributor_id = @distributorID
WHERE purchase_id = @purchaseID;

-- delete a purchase if it was entered incorrectly or should be removed
DELETE FROM Purchases
WHERE purchase_id = @purchaseID;


-- -----------------------------------------------------
-- PurchaseItems
-- -----------------------------------------------------

SELECT PurchaseItems.purchase_item_id, PurchaseItems.purchase_id,
       PurchaseItems.inventory_id, Inventory.sku, Inventory.inventory_type,
       Inventory.brand_name, PurchaseItems.quantity_purchased,
       PurchaseItems.price_paid
FROM PurchaseItems
INNER JOIN Purchases
    ON PurchaseItems.purchase_id = Purchases.purchase_id
INNER JOIN Inventory
    ON PurchaseItems.inventory_id = Inventory.inventory_id;

SELECT Purchases.purchase_id, Purchases.purchase_date,
       Purchases.distributor_id, Distributors.distributor_name
FROM Purchases
INNER JOIN Distributors
    ON Purchases.distributor_id = Distributors.distributor_id;

-- get inventory options for the purchase item add and update forms
SELECT inventory_id, sku, inventory_type, brand_name
FROM Inventory;

-- add an item to a purchase when inventory is bought from a distributor
INSERT INTO PurchaseItems (
    purchase_id,
    inventory_id,
    quantity_purchased,
    price_paid
)
VALUES (
    @purchaseID,
    @inventoryID,
    @quantityPurchased,
    @pricePaid
);

-- update a purchase item if the item, quantity, or price paid needs to be corrected
UPDATE PurchaseItems
SET purchase_id = @purchaseID,
    inventory_id = @inventoryID,
    quantity_purchased = @quantityPurchased,
    price_paid = @pricePaid
WHERE purchase_item_id = @purchaseItemID;

-- delete a purchase item if it was added to the wrong purchase or should be removed
DELETE FROM PurchaseItems
WHERE purchase_item_id = @purchaseItemID;

-- ============================================================
-- Website Procedure Calls
-- ============================================================

-- Add a new inventory item from the Inventory create form
CALL sp_create_inventory(
    @sku,
    @inventoryType,
    @brandName,
    @distributorID,
    @retailPrice,
    @quantityInStock
);

-- Update an existing inventory item from the Inventory update form
CALL sp_update_inventory(
    @inventoryID,
    @sku,
    @inventoryType,
    @brandName,
    @distributorID,
    @retailPrice,
    @quantityInStock
);

-- Delete an inventory item selected from the Inventory table
CALL sp_delete_inventory(@inventoryID);

-- Add a product to an order in the OrderItems intersection table
CALL sp_create_orderitem(
    @orderID,
    @inventoryID,
    @quantity,
    @discountPercent,
    @sellingPrice,
    @shipped,
    @shippingDate
);

-- Update an OrderItems row.
CALL sp_update_orderitem(
    @orderItemID,
    @inventoryID,
    @quantity,
    @discountPercent,
    @sellingPrice,
    @shipped,
    @shippingDate
);

-- Delete a product from an order in the OrderItems intersection table
CALL sp_delete_orderitem(@orderItemID);

-- Add a new customer from the Customers create form
CALL sp_create_customer(
    @firstName,
    @lastName,
    @street,
    @city,
    @state,
    @zip,
    @phone,
    @email
);

-- Update an existing customer from the Customers update form
CALL sp_update_customer(
    @customerID,
    @firstName,
    @lastName,
    @street,
    @city,
    @state,
    @zip,
    @phone,
    @email
);

-- Delete a customer selected from the Customers table
CALL sp_delete_customer(@customerID);


-- Add a new distributor from the Distributors create form
CALL sp_create_distributor(
    @distributorName,
    @street,
    @city,
    @state,
    @zip,
    @phone,
    @contactPerson
);

-- Update an existing distributor from the Distributors update form
CALL sp_update_distributor(
    @distributorID,
    @distributorName,
    @street,
    @city,
    @state,
    @zip,
    @phone,
    @contactPerson
);

-- Delete a distributor selected from the Distributors table
CALL sp_delete_distributor(@distributorID);


-- Add a new order from the Orders create form
CALL sp_create_order(
    @customerID,
    @orderDate,
    @paymentMethod,
    @paymentLastFour,
    @orderComplete,
    @pickupOrShip
);

-- Update an existing order from the Orders update form
CALL sp_update_order(
    @orderID,
    @paymentMethod,
    @paymentLastFour,
    @orderComplete,
    @pickupOrShip
);

-- Delete an order selected from the Orders table
CALL sp_delete_order(@orderID);


-- Add a new purchase from the Purchases create form
CALL sp_create_purchase(
    @purchaseDate,
    @distributorID
);

-- Update an existing purchase from the Purchases update form
CALL sp_update_purchase(
    @purchaseID,
    @purchaseDate,
    @distributorID
);

-- Delete a purchase selected from the Purchases table
CALL sp_delete_purchase(@purchaseID);


-- Add a new purchase item from the PurchaseItems create form
CALL sp_create_purchaseitem(
    @purchaseID,
    @inventoryID,
    @quantityPurchased,
    @pricePaid
);

-- Update an existing purchase item from the PurchaseItems update form
CALL sp_update_purchaseitem(
    @purchaseItemID,
    @purchaseID,
    @inventoryID,
    @quantityPurchased,
    @pricePaid
);

-- Delete a purchase item selected from the PurchaseItems table
CALL sp_delete_purchaseitem(@purchaseItemID);

-- Reset the database back to the sample data
CALL sp_load_peakapparel();
