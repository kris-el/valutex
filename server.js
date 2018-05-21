var env = process.env.NODE_ENV || 'development';
var express = require('express');
var bodyParser = require('body-parser');

var {mongoose} = require('./app/mongoose');
var {User} = require('./app/models/user');
var {Exchange} = require('./app/models/exchange');


const port = process.env.PORT || 3000;
var app = express();

app.use(express.static(__dirname + '/public'));
app.use(bodyParser.json());

require('./app/routes')(app, {});

app.get('/save-exchange', (req, res) => {
  var exchange = new Exchange({
    base: "EUR",
    rates: "123456",
  });
  exchange.save().then((doc) => {
    res.send(doc);
  }, (e) => {
    res.status(400).send(e);
  });
});

app.get('/get-exchanges', (req, res) => {
  Exchange.find().then((exchanges) => {
    res.send({exchanges});
  }, (e) => {
    res.status(400).send(e);
  });
})


app.listen(port, () => {
  console.log(`Server is up on port ${port}`);
});
