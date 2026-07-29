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

app.get('/inventory', (req, res) => {
    res.render('inventory');
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

app.listen(PORT, () => {
    console.log('Express started on http://localhost:' + PORT + '; press Ctrl-C to terminate.');
});