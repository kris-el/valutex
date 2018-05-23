var env = process.env.NODE_ENV || 'development';
var express = require('express');

var {mongoose} = require('./app/mongoose');

const port = process.env.PORT || 3000;
var app = express();

app.use(express.static(__dirname + '/public'));


app.listen(port, () => {
  console.log(`Server is up on port ${port}`);
});
