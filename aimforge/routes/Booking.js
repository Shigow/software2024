const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');

const bookings = require('../models/booking');
const mongo = require('mongodb');

const bookingRouter = express.Router();

//all of the endpoints / URI's

bookingRouter.get('/help', function(req, res, next) {
    res.render('help', { title: 'help' });
});
bookingRouter.get('/', function(req, res, next) {
    res.render('home', { title: 'home' })
});
bookingRouter.get('/table', function(req, res, next) {
    res.render('table', { title: 'table' })
})

bookingRouter.route('/')
    .get((req, res, next) => {
        res.end("just checking --> nothing to do")
    })

    bookingRouter.route('/create')
    .get((req, res, next) => {
        res.render('newbooking.ejs', { title: 'AimForge' });
    })


//Creating a new entry, sending to mongo, finding the data, rendering table page
.post((req, res, next) => {
    bookings.create(req.body)
        .then((bookingcreated) => {
            bookings.find()
                .then((bookingsfound) => {
                    res.render('table.ejs', { 'bookinglist': bookingsfound, title: 'All bookings' });
                }, (err) => next(err))
                .catch((err) => next(err));
        }, (err) => next(err))
        .catch((err) => next(err));
})


// error pages...
.put((req, res, next) => {
        res.send('PUT operation not supported on /phones/create');
    })
    // error pages
    .delete((req, res, next) => {
        res.end('Delete operation not  supported on /phones/create');

    });
//deleting user by id
bookingRouter.route('/delete')
    .post((req, res, next) => {
        bookings.findByIdAndDelete(req.body.id).then(reportsfound => {
                res.render("success.ejs", { title: "table page" });

            }, (err) => next(err))
            .catch((err) => next(err));
    });


//takes the id of the user you want to update/edit, puts details on page
bookingRouter.route('/update')
    .post((req, res, next) => {
        bookings.findByIdAndUpdate({ _id: req.body.id })
            .then((bookingsfound) => {
                console.log(bookingsfound);
                res.render("updatePage.ejs", { "bookinglist": bookingsfound, title: "Editing bookings" });
            }, (err) => next(err))
            .catch((err) => next(err));
    }, (err) => next(err));

//once you submit the new form with updated data, it updates the mongodb, renders a "update successful" page
bookingRouter.route('/updateComplete')
    .post((req, res, next) => {
        bookings.findByIdAndUpdate(req.body.id, req.body)
            .then(bookings.find()
                .then((bookingsfound) => {
                    res.render("updatesuccess.ejs", { "bookinglist": bookingsfound, title: "Editing reports" });
                }, (err) => next(err))
                .catch((err) => next(err)));
    })


// report generation   
bookingRouter.get('/reportform', async (req, res) => {
    const { userName, startDate, endDate } = req.body;

    try {
        const booking = await bookings.find({
            name: userName,
            dateTime: {
                $gte: new Date(startDate),
                $lte: new Date(endDate)
            } 
        });

        //rendering the report page and passing bookings onto it
        res.render('report', { booking, userName, startDate, endDate });
    } catch (err) {
        console.error(err);
        res.status(500).send('Internal Server Error')
    }
});

module.exports = bookingRouter; //exports from this file so that other files are allowed to access the exported code