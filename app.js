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

app.get('/customers', (req, res) => {
    res.render('customers');
});

app.get('/orders', (req, res) => {
    res.render('orders');
});

app.get('/orderitems', (req, res) => {
    res.render('orderitems');
});

app.get('/inventory', async function (req, res) {
    try {
        const query = `SELECT Inventory.inventory_id, Inventory.sku, Inventory.inventory_type,
                              Inventory.brand_name, Distributors.distributor_name,
                              Inventory.retail_price, Inventory.quantity_in_stock
                       FROM Inventory
                       INNER JOIN Distributors
                           ON Inventory.distributor_id = Distributors.distributor_id;`;
        const [inventory] = await db.query(query);
        res.render('inventory', { inventory: inventory });
    } catch (error) {
        console.error('Error loading inventory:', error);
        res.status(500).send('An error occurred loading inventory.');
    }
});

app.get('/distributors', (req, res) => {
    res.render('distributors');
});

app.get('/purchases', (req, res) => {
    res.render('purchases');
});

app.get('/purchaseitems', (req, res) => {
    res.render('purchaseitems');
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

// Demo CUD operation: deletes one inventory item so the RESET can be verified
app.post('/inventory/delete-demo', async function (req, res) {
    try {
        await db.query('CALL sp_delete_demo_item();');
        res.redirect('/inventory');
    } catch (error) {
        console.error('Error executing demo delete:', error);
        res.status(500).send('An error occurred during the demo delete.');
    }
});

app.listen(PORT, () => {
    console.log('Express started on http://localhost:' + PORT + '; press Ctrl-C to terminate.');
});