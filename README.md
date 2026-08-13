# Peak Apparel Co. Inventory Management System

## Project Overview

This project is a database website for Peak Apparel Co. The system helps manage customers, orders, order items, inventory, distributors, purchases, and purchase items in one place.

Peak Apparel Co. sells clothing items from different brands and distributors, so the main goal of this project is to make it easier to track what products are in stock, where they come from, and how they connect to customer orders and distributor purchases.

## Team Members

- Julie Glass
- Abhijeet Singh

## Group Number

Group 15

## Technologies Used

- Node.js
- Express
- Express Handlebars
- MySQL / MariaDB
- mysql2
- HTML
- CSS
- JavaScript

## How to Run the Project

First, install the required dependencies:

npm install

Then start the server:

npm start

The app will run on the port listed in app.js.

## Website Pages

The website has pages for:

- Customers
- Orders
- Order Items
- Inventory
- Distributors
- Purchases
- Purchase Items

Each page lets the user browse records and use Create, Update, and Delete operations.

## Database Design

The final database uses seven tables:

- Customers
- Orders
- OrderItems
- Inventory
- Distributors
- Purchases
- PurchaseItems

OrderItems is used as the intersection table between Orders and Inventory.

PurchaseItems is used as the intersection table between Purchases and Inventory.

This helps handle the many-to-many relationships in the database.

## Main Features

The website includes:

- Browse tables for all entities
- Create forms for adding new records
- Update forms for changing existing records
- Delete buttons for removing records
- Dropdowns for foreign key values
- Stored procedures for Create, Update, and Delete operations
- A RESET button to reload the original sample data

## Database Reset

The database can be reset using the reset button on the website. This calls a stored procedure that drops and recreates the tables, inserts the original sample data, and turns foreign key checks back on after the reset is complete.

## Citation / AI Assistance

This project was created for the CS340 Portfolio Project.

We used CS340 course materials to help with the basic project setup, including Express routes, Handlebars pages, the MySQL connection, and CRUD patterns.

ChatGPT was used in August 2026 to help brainstorm project ideas, understand errors we were receiving, and check final testing issues. All errors or final checks were done by us with the help of AI to understand the error. 