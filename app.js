const db = require('./database/db-connector');
const express = require('express');
const { engine } = require('express-handlebars');

const app = express();
const PORT = 8361;

app.engine('.hbs', engine({ extname: '.hbs' }));
app.set('view engine', '.hbs');
app.set('views', './views');

app.use(express.static('public'));
app.use(express.urlencoded({ extended: true }));

app.get('/', (req, res) => {
    res.render('index');
});

app.get('/customers', async function (req, res) {
    try {
        const query = `SELECT customer_id, customer_first_name, customer_last_name,
                              customer_street, customer_city, customer_state,
                              customer_zip, customer_phone, customer_email
                       FROM Customers
                       ORDER BY customer_id;`;
        const [customers] = await db.query(query);
        res.render('customers', { customers: customers });
    } catch (error) {
        console.error('Error loading customers:', error);
        res.status(500).send('An error occurred loading customers.');
    }
});

app.get('/orders', async function (req, res) {
    try {
        const query = `SELECT Orders.order_id, Orders.customer_id,
                              Customers.customer_first_name, Customers.customer_last_name,
                              Orders.order_date, Orders.payment_method,
                              Orders.payment_last_four, Orders.order_complete,
                              Orders.pickup_or_ship
                       FROM Orders
                       INNER JOIN Customers
                           ON Orders.customer_id = Customers.customer_id
                        ORDER BY Orders.order_id;`;
        const [orders] = await db.query(query);
        res.render('orders', { orders: orders });
    } catch (error) {
        console.error('Error loading orders:', error);
        res.status(500).send('An error occurred loading orders.');
    }
});

app.get('/orderitems', async function (req, res) {
    try {
        const query = `SELECT OrderItems.order_item_id, OrderItems.order_id,
                              OrderItems.inventory_id, Inventory.sku,
                              Inventory.inventory_type, Inventory.brand_name,
                              OrderItems.quantity, OrderItems.discount_percent,
                              OrderItems.selling_price, OrderItems.shipped,
                              OrderItems.shipping_date
                       FROM OrderItems
                       INNER JOIN Orders
                           ON OrderItems.order_id = Orders.order_id
                       INNER JOIN Inventory
                           ON OrderItems.inventory_id = Inventory.inventory_id
                        ORDER BY OrderItems.order_item_id;`;
        const [orderitems] = await db.query(query);
        res.render('orderitems', { orderitems: orderitems });
    } catch (error) {
        console.error('Error loading order items:', error);
        res.status(500).send('An error occurred loading order items.');
    }
});

app.get('/inventory', async function (req, res) {
    try {
        const query = `SELECT Inventory.inventory_id, Inventory.sku, Inventory.inventory_type,
                              Inventory.brand_name, Distributors.distributor_name,
                              Inventory.retail_price, Inventory.quantity_in_stock
                       FROM Inventory
                       INNER JOIN Distributors
                           ON Inventory.distributor_id = Distributors.distributor_id
                        ORDER BY Inventory.inventory_id;`;
        const [inventory] = await db.query(query);
        res.render('inventory', { inventory: inventory });
    } catch (error) {
        console.error('Error loading inventory:', error);
        res.status(500).send('An error occurred loading inventory.');
    }
});

app.get('/distributors', async function (req, res) {
    try {
        const query = `SELECT distributor_id, distributor_name, distributor_street,
                              distributor_city, distributor_state, distributor_zip,
                              distributor_phone, distributor_contact_person
                       FROM Distributors
                       ORDER BY distributor_id;`;
        const [distributors] = await db.query(query);
        res.render('distributors', { distributors: distributors });
    } catch (error) {
        console.error('Error loading distributors:', error);
        res.status(500).send('An error occurred loading distributors.');
    }
});

app.get('/purchases', async function (req, res) {
    try {
        const query = `SELECT Purchases.purchase_id, Purchases.purchase_date,
                              Purchases.distributor_id, Distributors.distributor_name
                       FROM Purchases
                       INNER JOIN Distributors
                           ON Purchases.distributor_id = Distributors.distributor_id
                        ORDER BY Purchases.purchase_id;`;
        const [purchases] = await db.query(query);
        res.render('purchases', { purchases: purchases });
    } catch (error) {
        console.error('Error loading purchases:', error);
        res.status(500).send('An error occurred loading purchases.');
    }
});

app.get('/purchaseitems', async function (req, res) {
    try {
        const query = `SELECT PurchaseItems.purchase_item_id, PurchaseItems.purchase_id,
                              PurchaseItems.inventory_id, Inventory.sku,
                              Inventory.inventory_type, Inventory.brand_name,
                              PurchaseItems.quantity_purchased, PurchaseItems.price_paid
                       FROM PurchaseItems
                       INNER JOIN Purchases
                           ON PurchaseItems.purchase_id = Purchases.purchase_id
                       INNER JOIN Inventory
                           ON PurchaseItems.inventory_id = Inventory.inventory_id
                        ORDER BY PurchaseItems.purchase_item_id;`;
        const [purchaseitems] = await db.query(query);
        res.render('purchaseitems', { purchaseitems: purchaseitems });
    } catch (error) {
        console.error('Error loading purchase items:', error);
        res.status(500).send('An error occurred loading purchase items.');
    }
});

// RESET route: calls the stored procedure that rebuilds the schema and sample data
app.post('/reset', async function (req, res) {
    try {
        await db.query('CALL sp_load_peakapparel();');
        res.redirect('/');
    } catch (error) {
        console.error('Error running RESET:', error);
        res.status(500).send('An error occurred while resetting the database.');
    }
});

// Inventory CUD operation: deletes one inventory item so the RESET can be verified
app.post('/inventory/delete-inventory', async function (req, res) {
    try {
        const inventoryID = req.body.inventory_id;
        await db.query('CALL sp_delete_inventory(?);', [inventoryID]);
        res.redirect('/inventory');
    } catch (error) {
        console.error('Error executing inventory delete:', error);
        res.status(500).send('An error occurred during the inventory delete.');
    }
});

// Inventory CREATE operation
app.post('/inventory/create', async function (req, res) {
    try {
        const {
            sku,
            inventory_type,
            brand_name,
            distributor_id,
            retail_price,
            quantity_in_stock
        } = req.body;

        await db.query(
            'CALL sp_create_inventory(?, ?, ?, ?, ?, ?);',
            [sku, inventory_type, brand_name, distributor_id, retail_price, quantity_in_stock]
        );

        res.redirect('/inventory');
    } catch (error) {
        console.error('Error creating inventory item:', error);
        res.status(500).send('An error occurred while creating the inventory item.');
    }
});


// Inventory UPDATE operation
app.post('/inventory/update', async function (req, res) {
    try {
        const {
            inventory_id,
            sku,
            inventory_type,
            brand_name,
            distributor_id,
            retail_price,
            quantity_in_stock
        } = req.body;

        await db.query(
            'CALL sp_update_inventory(?, ?, ?, ?, ?, ?, ?);',
            [inventory_id, sku, inventory_type, brand_name, distributor_id, retail_price, quantity_in_stock]
        );

        res.redirect('/inventory');
    } catch (error) {
        console.error('Error updating inventory item:', error);
        res.status(500).send('An error occurred while updating the inventory item.');
    }
});


// OrderItems CREATE operation
app.post('/orderitems/create', async function (req, res) {
    try {
        const {
            order_id,
            inventory_id,
            quantity,
            discount_percent,
            selling_price,
            shipped,
            shipping_date
        } = req.body;

        const shippedValue = shipped === '' ? null : shipped;
        const shippingDateValue = shipping_date === '' ? null : shipping_date;

        await db.query(
            'CALL sp_create_orderitem(?, ?, ?, ?, ?, ?, ?);',
            [order_id, inventory_id, quantity, discount_percent, selling_price, shippedValue, shippingDateValue]
        );

        res.redirect('/orderitems');
    } catch (error) {
        console.error('Error creating order item:', error);
        res.status(500).send('An error occurred while creating the order item.');
    }
});


// OrderItems UPDATE M:N operation
app.post('/orderitems/update', async function (req, res) {
    try {
        const {
            order_item_id,
            inventory_id,
            quantity,
            discount_percent,
            selling_price,
            shipped,
            shipping_date
        } = req.body;

        const shippedValue = shipped === '' ? null : shipped;
        const shippingDateValue = shipping_date === '' ? null : shipping_date;

        await db.query(
            'CALL sp_update_orderitem(?, ?, ?, ?, ?, ?, ?);',
            [order_item_id, inventory_id, quantity, discount_percent, selling_price, shippedValue, shippingDateValue]
        );

        res.redirect('/orderitems');
    } catch (error) {
        console.error('Error updating order item:', error);
        res.status(500).send('An error occurred while updating the order item.');
    }
});


// OrderItems DELETE M:N operation
app.post('/orderitems/delete', async function (req, res) {
    try {
        const orderItemID = req.body.order_item_id;

        await db.query('CALL sp_delete_orderitem(?);', [orderItemID]);

        res.redirect('/orderitems');
    } catch (error) {
        console.error('Error deleting order item:', error);
        res.status(500).send('An error occurred while deleting the order item.');
    }
});


// Customers CREATE operation
app.post('/customers/create', async function (req, res) {
    try {
        const {
            customer_first_name,
            customer_last_name,
            customer_street,
            customer_city,
            customer_state,
            customer_zip,
            customer_phone,
            customer_email
        } = req.body;

        await db.query(
            'CALL sp_create_customer(?, ?, ?, ?, ?, ?, ?, ?);',
            [
                customer_first_name,
                customer_last_name,
                customer_street,
                customer_city,
                customer_state,
                customer_zip,
                customer_phone,
                customer_email
            ]
        );

        res.redirect('/customers');
    } catch (error) {
        console.error('Error creating customer:', error);
        res.status(500).send('An error occurred while creating the customer.');
    }
});


// Customers UPDATE operation
app.post('/customers/update', async function (req, res) {
    try {
        const {
            customer_id,
            customer_first_name,
            customer_last_name,
            customer_street,
            customer_city,
            customer_state,
            customer_zip,
            customer_phone,
            customer_email
        } = req.body;

        await db.query(
            'CALL sp_update_customer(?, ?, ?, ?, ?, ?, ?, ?, ?);',
            [
                customer_id,
                customer_first_name,
                customer_last_name,
                customer_street,
                customer_city,
                customer_state,
                customer_zip,
                customer_phone,
                customer_email
            ]
        );

        res.redirect('/customers');
    } catch (error) {
        console.error('Error updating customer:', error);
        res.status(500).send('An error occurred while updating the customer.');
    }
});


// Customers DELETE operation
app.post('/customers/delete', async function (req, res) {
    try {
        const customerID = req.body.customer_id;

        await db.query('CALL sp_delete_customer(?);', [customerID]);

        res.redirect('/customers');
    } catch (error) {
        console.error('Error deleting customer:', error);
        res.status(500).send('An error occurred while deleting the customer.');
    }
});


// Distributors CREATE operation
app.post('/distributors/create', async function (req, res) {
    try {
        const {
            distributor_name,
            distributor_street,
            distributor_city,
            distributor_state,
            distributor_zip,
            distributor_phone,
            distributor_contact_person
        } = req.body;

        await db.query(
            'CALL sp_create_distributor(?, ?, ?, ?, ?, ?, ?);',
            [
                distributor_name,
                distributor_street,
                distributor_city,
                distributor_state,
                distributor_zip,
                distributor_phone,
                distributor_contact_person
            ]
        );

        res.redirect('/distributors');
    } catch (error) {
        console.error('Error creating distributor:', error);
        res.status(500).send('An error occurred while creating the distributor.');
    }
});


// Distributors UPDATE operation
app.post('/distributors/update', async function (req, res) {
    try {
        const {
            distributor_id,
            distributor_name,
            distributor_street,
            distributor_city,
            distributor_state,
            distributor_zip,
            distributor_phone,
            distributor_contact_person
        } = req.body;

        await db.query(
            'CALL sp_update_distributor(?, ?, ?, ?, ?, ?, ?, ?);',
            [
                distributor_id,
                distributor_name,
                distributor_street,
                distributor_city,
                distributor_state,
                distributor_zip,
                distributor_phone,
                distributor_contact_person
            ]
        );

        res.redirect('/distributors');
    } catch (error) {
        console.error('Error updating distributor:', error);
        res.status(500).send('An error occurred while updating the distributor.');
    }
});


// Distributors DELETE operation
app.post('/distributors/delete', async function (req, res) {
    try {
        const distributorID = req.body.distributor_id;

        await db.query('CALL sp_delete_distributor(?);', [distributorID]);

        res.redirect('/distributors');
    } catch (error) {
        console.error('Error deleting distributor:', error);
        res.status(500).send('An error occurred while deleting the distributor.');
    }
});


// Orders CREATE operation
app.post('/orders/create', async function (req, res) {
    try {
        const {
            customer_id,
            order_date,
            payment_method,
            payment_last_four,
            order_complete,
            pickup_or_ship
        } = req.body;

        await db.query(
            'CALL sp_create_order(?, ?, ?, ?, ?, ?);',
            [
                customer_id,
                order_date,
                payment_method,
                payment_last_four,
                order_complete,
                pickup_or_ship
            ]
        );

        res.redirect('/orders');
    } catch (error) {
        console.error('Error creating order:', error);
        res.status(500).send('An error occurred while creating the order.');
    }
});


// Orders UPDATE operation
app.post('/orders/update', async function (req, res) {
    try {
        const {
            order_id,
            order_complete,
            pickup_or_ship
        } = req.body;

        await db.query(
            'CALL sp_update_order(?, ?, ?);',
            [order_id, order_complete, pickup_or_ship]
        );

        res.redirect('/orders');
    } catch (error) {
        console.error('Error updating order:', error);
        res.status(500).send('An error occurred while updating the order.');
    }
});


// Orders DELETE operation
app.post('/orders/delete', async function (req, res) {
    try {
        const orderID = req.body.order_id;

        await db.query('CALL sp_delete_order(?);', [orderID]);

        res.redirect('/orders');
    } catch (error) {
        console.error('Error deleting order:', error);
        res.status(500).send('An error occurred while deleting the order.');
    }
});


// Purchases CREATE operation
app.post('/purchases/create', async function (req, res) {
    try {
        const {
            purchase_date,
            distributor_id
        } = req.body;

        await db.query(
            'CALL sp_create_purchase(?, ?);',
            [purchase_date, distributor_id]
        );

        res.redirect('/purchases');
    } catch (error) {
        console.error('Error creating purchase:', error);
        res.status(500).send('An error occurred while creating the purchase.');
    }
});


// Purchases UPDATE operation
app.post('/purchases/update', async function (req, res) {
    try {
        const {
            purchase_id,
            purchase_date,
            distributor_id
        } = req.body;

        await db.query(
            'CALL sp_update_purchase(?, ?, ?);',
            [purchase_id, purchase_date, distributor_id]
        );

        res.redirect('/purchases');
    } catch (error) {
        console.error('Error updating purchase:', error);
        res.status(500).send('An error occurred while updating the purchase.');
    }
});


// Purchases DELETE operation
app.post('/purchases/delete', async function (req, res) {
    try {
        const purchaseID = req.body.purchase_id;

        await db.query('CALL sp_delete_purchase(?);', [purchaseID]);

        res.redirect('/purchases');
    } catch (error) {
        console.error('Error deleting purchase:', error);
        res.status(500).send('An error occurred while deleting the purchase.');
    }
});


app.listen(PORT, () => {
    console.log('Express started on http://localhost:' + PORT + '; press Ctrl-C to terminate.');
});