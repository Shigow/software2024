var express = require('express');
var router = express.Router();
const bookings = require('../models/booking');

//all of the endpoints / URI's
router.get('/', function(req, res, next) {
    res.render('home', { title: 'home' });
});
router.get('/help', function(req, res, next) {
    res.send('This is the help Page');
});
router.get('/table', function(req, res) {
    bookings.find().then((bookingsfound) => {
        res.render('table', { 'bookinglist': bookingsfound, title: 'tablepage' });
    })
});
router.get('/about', function(req, res, next) {
    res.send('This is the about Page');
});

router.get('/reportform', function(req, res, next) {
    res.render('reportform', { title: 'Report'})
});


module.exports = router; //exports from this file so that other files are allowed to access the exported code
