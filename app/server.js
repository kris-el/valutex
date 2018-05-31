var config = require('./config');

const express = require('express');
const bodyParser = require('body-parser');
const currency = require('./currency');

var {debug} = require('./debug');
var {mongoose} = require('./mongoose');
var {User} = require('./models/user');
var {Exchange} = require('./models/exchange');
var {Note} = require('./models/note');

var app = express();

app.use(express.static(__dirname + '/public'));
app.use(bodyParser.json());

//require('./routes/sample')(app);
require('./routes/note')(app, debug, Note);
require('./routes/user')(app, debug, User);
require('./routes/exchange')(app, debug, currency, Exchange);

app.listen(process.env.PORT, () => {
  console.log(`Server is up on port ${process.env.PORT}`);
});

module.exports = {app, debug};
