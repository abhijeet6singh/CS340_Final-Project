-- Project Step 2 Draft
-- Team Members: Julie Glass & Abhijeet Singh
-- Group Number: 15
-- Project Title: Peak Apparel Co. Inventory Management System

SET FOREIGN_KEY_CHECKS = 0;
SET AUTOCOMMIT = 0;
START TRANSACTION;

DROP TABLE IF EXISTS PurchaseItems;
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Purchases;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS Distributors;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT NOT NULL,
    customer_first_name VARCHAR(50) NOT NULL,
    customer_last_name VARCHAR(50) NOT NULL,
    customer_street VARCHAR(100),
    customer_city VARCHAR(50),
    customer_state VARCHAR(2),
    customer_zip VARCHAR(10),
    customer_phone VARCHAR(20),
    customer_email VARCHAR(100),
    PRIMARY KEY (customer_id)
);

CREATE TABLE Distributors (
    distributor_id INT AUTO_INCREMENT NOT NULL,
    distributor_name VARCHAR(100) NOT NULL,
    distributor_street VARCHAR(100),
    distributor_city VARCHAR(50),
    distributor_state VARCHAR(2),
    distributor_zip VARCHAR(10),
    distributor_phone VARCHAR(20),
    distributor_contact_person VARCHAR(100),
    PRIMARY KEY (distributor_id)
);

CREATE TABLE Inventory (
    inventory_id INT AUTO_INCREMENT NOT NULL,
    sku VARCHAR(50) UNIQUE NOT NULL,
    inventory_type VARCHAR(50) NOT NULL,
    brand_name VARCHAR(100) NOT NULL,
    distributor_id INT NOT NULL,
    retail_price DECIMAL(10,2) NOT NULL,
    quantity_in_stock INT NOT NULL,
    PRIMARY KEY (inventory_id),
    FOREIGN KEY (distributor_id) REFERENCES Distributors(distributor_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT NOT NULL,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    payment_method VARCHAR(50),
    payment_last_four VARCHAR(4),
    order_complete BOOLEAN NOT NULL,
    pickup_or_ship VARCHAR(20) NOT NULL,
    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE OrderItems (
    order_item_id INT AUTO_INCREMENT NOT NULL,
    order_id INT NOT NULL,
    inventory_id INT NOT NULL,
    quantity INT NOT NULL,
    discount_percent DECIMAL(5,2),
    selling_price DECIMAL(10,2) NOT NULL,
    shipped BOOLEAN,
    shipping_date DATE,
    PRIMARY KEY (order_item_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (inventory_id) REFERENCES Inventory(inventory_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Purchases (
    purchase_id INT AUTO_INCREMENT NOT NULL,
    purchase_date DATE NOT NULL,
    distributor_id INT NOT NULL,
    PRIMARY KEY (purchase_id),
    FOREIGN KEY (distributor_id) REFERENCES Distributors(distributor_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE PurchaseItems (
    purchase_item_id INT AUTO_INCREMENT NOT NULL,
    purchase_id INT NOT NULL,
    inventory_id INT NOT NULL,
    quantity_purchased INT NOT NULL,
    price_paid DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (purchase_item_id),
    FOREIGN KEY (purchase_id) REFERENCES Purchases(purchase_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (inventory_id) REFERENCES Inventory(inventory_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

INSERT INTO Customers (
    customer_id,
    customer_first_name,
    customer_last_name,
    customer_street,
    customer_city,
    customer_state,
    customer_zip,
    customer_phone,
    customer_email
)
VALUES
(1, 'Maya', 'Torres', '412 Alder St', 'Corvallis', 'OR', '97330', '541-555-0142', 'maya.t@example.com'),
(2, 'Devon', 'Park', '88 NW Harrison Blvd', 'Corvallis', 'OR', '97330', '541-555-0177', 'dpark@example.com'),
(3, 'Lena', 'Fischer', '1520 SE Division St', 'Portland', 'OR', '97202', '503-555-0110', 'lenaf@example.com');

INSERT INTO Distributors (
    distributor_id,
    distributor_name,
    distributor_street,
    distributor_city,
    distributor_state,
    distributor_zip,
    distributor_phone,
    distributor_contact_person
)
VALUES
(1, 'Cascade Apparel Supply', '900 NW Industrial Way', 'Portland', 'OR', '97209', '503-555-0233', 'Rita Salazar'),
(2, 'Pacific Garment Wholesale', '4410 1st Ave S', 'Seattle', 'WA', '98134', '206-555-0189', 'James Okafor'),
(3, 'Northwest Outdoor Apparel', '275 Riverfront Ave', 'Eugene', 'OR', '97401', '541-555-0198', 'Elena Brooks');

INSERT INTO Inventory (
    inventory_id,
    sku,
    inventory_type,
    brand_name,
    distributor_id,
    retail_price,
    quantity_in_stock
)
VALUES
(101, 'JKT-204', 'Rain Jacket', 'Columbia', 1, 89.99, 12),
(102, 'JNS-310', 'Jeans', 'Levi''s', 2, 54.99, 8),
(103, 'HDY-118', 'Hoodie', 'Carhartt', 1, 42.50, 20),
(104, 'BNE-055', 'Beanie', 'Patagonia', 3, 34.99, 15);

INSERT INTO Orders (
    order_id,
    customer_id,
    order_date,
    payment_method,
    payment_last_four,
    order_complete,
    pickup_or_ship
)
VALUES
(3001, 1, '2026-07-03', 'credit', '4821', 1, 'pickup'),
(3002, 1, '2026-07-10', 'debit', '7754', 1, 'ship'),
(3003, 2, '2026-07-12', 'credit', '1096', 0, 'ship'),
(3004, 3, '2026-07-15', 'cash', NULL, 1, 'pickup');

INSERT INTO OrderItems (
    order_item_id,
    order_id,
    inventory_id,
    quantity,
    discount_percent,
    selling_price,
    shipped,
    shipping_date
)
VALUES
(7001, 3001, 101, 1, 0.00, 89.99, NULL, NULL),
(7002, 3001, 104, 1, 10.00, 31.49, NULL, NULL),
(7003, 3002, 103, 2, 0.00, 42.50, 1, '2026-07-11'),
(7004, 3003, 102, 1, 15.00, 46.74, 0, NULL),
(7005, 3004, 101, 1, 0.00, 89.99, NULL, NULL);

INSERT INTO Purchases (
    purchase_id,
    purchase_date,
    distributor_id
)
VALUES
(5001, '2026-06-02', 1),
(5002, '2026-06-15', 2),
(5003, '2026-07-01', 3);

INSERT INTO PurchaseItems (
    purchase_item_id,
    purchase_id,
    inventory_id,
    quantity_purchased,
    price_paid
)
VALUES
(9001, 5001, 101, 8, 51.00),
(9002, 5001, 103, 10, 24.75),
(9003, 5002, 102, 6, 31.50),
(9004, 5002, 102, 15, 29.25),
(9005, 5003, 104, 10, 19.25);

SET FOREIGN_KEY_CHECKS = 1;
COMMIT;