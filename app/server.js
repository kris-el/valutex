var env = process.env.NODE_ENV || 'development';
var config = require('./config')[env];
var express = require('express');
var bodyParser = require('body-parser');
const currency = require('./currency');

var {mongoose} = require('./mongoose');
var {User} = require('./models/user');
var {Exchange} = require('./models/exchange');
var {Note} = require('./models/note');

const port = process.env.PORT || 3000;
var app = express();

app.use(express.static(__dirname + '/public'));
app.use(bodyParser.json());

app.get('/test-plain', (req, res) => {
  res.send('Hello');
});

app.post('/test-json', (req, res) => {
  var inputText = req.body.input || "some data";
  var response = {
    output: inputText
  };
  res.send(response);
});

app.get('/getenv', (req, res) => {
  res.send('environment = ' + env);
});

app.post('/addnote', (req, res) => {
  var inputText = req.body.input;
  var note = new Note({
    text: inputText
  });
  note.save().then((doc) => {
    res.send(doc);
  }, (e) => {
    res.status(400).send(e);
  });
});

app.get('/getnotes', (req, res) => {
  Note.find().then((notes) => {
    res.send({notes});
  }, (e) => {
    res.status(400).send(e);
  });
});

app.get('/getrates', (req, res) => {
  currency.getData(config.fixer.api_key).then((data) => {
    // Save data into db
    res.send(data);
  }, (errorMessage) => {
    res.send(errorMessage);
  });
});

app.listen(port, () => {
  console.log(`Server is up on port ${port}`);
});
