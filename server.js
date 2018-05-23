var env = process.env.NODE_ENV || 'development';
var express = require('express');
var bodyParser = require('body-parser');

var {mongoose} = require('./app/mongoose');

const port = process.env.PORT || 3000;
var app = express();

app.use(express.static(__dirname + '/public'));
app.use(bodyParser.json());


app.listen(port, () => {
  console.log(`Server is up on port ${port}`);
});
