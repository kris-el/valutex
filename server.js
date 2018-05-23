var env = process.env.NODE_ENV || 'development';
var express = require('express');
var bodyParser = require('body-parser');

var {mongoose} = require('./app/mongoose');
var {User} = require('./app/models/user');
var {Exchange} = require('./app/models/exchange');
var {Note} = require('./app/models/note');

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

app.post('/addnote', (req, res) => {
  var inputText = req.body.input || "some data";
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


app.listen(port, () => {
  console.log(`Server is up on port ${port}`);
});
