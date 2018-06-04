var config = require('./config/config');

const express = require('express');
const bodyParser = require('body-parser');
var app = express();

var {debug} = require('./debug');
var {mongoose} = require('./mongoose');
var {authenticate} = require('./middleware/authenticate');
var routes = require('./routes')(debug, authenticate);



app.use(express.static(__dirname + '/../public'));
app.use(bodyParser.json());
app.use('/api', routes);

app.listen(process.env.PORT, () => {
  console.log(`Server is up on port ${process.env.PORT}`);
});

module.exports = {app, debug};
