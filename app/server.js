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

// hour  min  sec  msec
var twelveHoursAgo = new Date().getTime() - (12 * 60 * 60 * 1000);
var oneHoursAgo = new Date().getTime() - (1 * 60 * 60 * 1000);
app.get('/getrates', (req, res) => {
  // Get the most recent document
  Exchange.findOne().sort({age: -1}).then((recentExchange) => {
    if(recentExchange) {
      // Found at least one document
      console.log('Retrived exchange rate from history!');
      var documentTimestamp = (new Date(recentExchange.age).getTime());
      // If the document is less than one hour old
      if(documentTimestamp > oneHoursAgo) {
        console.log('The exchange rates are <1h old!');
        res.send(recentExchange);
      } else /*if (documentTimestamp > twelveHoursAgo) {
        console.log('The exchange rates are <12h >1h old!');
        res.send(recentExchange);
      } else {
        console.log('The exchange rates are >12h old!');*/
      {
        console.log('The exchange rates are >1h old!');
        currency.getData(config.fixer.api_key).then((data) => {
          var newExchange = new Exchange(data);
          newExchange.save().then((doc) => {
            // Add decoration to added document if necessary
            //...
            console.log('New exchange rate added and sent back!');
            res.send(doc);
          }, (e) => {
            console.log('Error saving the new exchange rates!');
            res.status(400).send(e);
          });
        }, (errorMessage) => {
          console.log('Error getting exchange rates. Old value is returned!');
          console.log(errorMessage);
          res.send(recentExchange);
          //res.send(errorMessage);
        });
      }
    } else {
      currency.getData(config.fixer.api_key).then((data) => {
        var newExchange = new Exchange(data);
        newExchange.save().then((doc) => {
          // Add decoration to added document if necessary
          //...
          console.log('First exchange rate added!');
          res.send(doc);
        }, (e) => {
          console.log('Error saving the first exchange rates!');
          res.status(400).send(e);
        });
      }, (errorMessage) => {
        // Respond with appropriate error message
        //...
        console.log('Error getting the first exchange rates!');
        res.status(400).send(errorMessage);
      });
    }
  }, (e) => {
    res.status(404).send(e);
  });
});

app.listen(port, () => {
  console.log(`Server is up on port ${port}`);
});