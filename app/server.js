var config = require('./config');

const _ = require('lodash');
var express = require('express');
var bodyParser = require('body-parser');
const currency = require('./currency');

var {mongoose} = require('./mongoose');
var {User} = require('./models/user');
var {Exchange} = require('./models/exchange');
var {Note} = require('./models/note');

var app = express();
var debug = {
  status: true,
  msg: [{relevance: 10, text: ''}],
  show: function() {
    if(this.status) {
      //console.log('\x1b[33m%s\x1b[0m', this.msg);
      for (i=0;i<this.msg.length;i++) {
        if(this.msg[i].relevance == 1) {
          console.log('\x1b[35m%s\x1b[0m', '    *** ' + this.msg[i].text + ' ***');
        }
        else {
          console.log('\x1b[34m%s\x1b[0m', '    ' + this.msg[i].text);
        }
      }
    }
  },
  addTitle: function(text) {
    this.msg.push({relevance:1, text});
  },
  add: function(text) { this.msg.push({relevance:10, text}); },
  reset: function() { this.msg = []; }
}

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

app.post('/adduser', (req, res) => {
  var body = _.pick(req.body, ['email', 'password']);
  var user = new User(body);

  user.save().then((user) => {
    res.send(user);
  }).catch((e) => {
    res.status(400).send(e);
  })
});

// hour  min  sec  msec
var twelveHoursAgo = new Date().getTime() - (12 * 60 * 60 * 1000);
var oneHoursAgo = new Date().getTime() - (1 * 60 * 60 * 1000);
app.get('/getrates', (req, res) => {
  debug.addTitle('GET /getrates');
  // Get the most recent document
  Exchange.findOne().sort({age: -1}).then((recentExchange) => {
    if(recentExchange) {
      // Found at least one document
      //debug.add('Retrived exchange rate from history!');
      var documentTimestamp = (new Date(recentExchange.age).getTime());
      // If the document is less than one hour old
      if(documentTimestamp > oneHoursAgo) {
        debug.add('The exchange rates are <1h old!');
        res.send(recentExchange);
      } else /*if (documentTimestamp > twelveHoursAgo) {
        console.log('The exchange rates are <12h >1h old!');
        res.send(recentExchange);
      } else {
        console.log('The exchange rates are >12h old!');*/
      {
        debug.add('The exchange rates are >1h old!');
        currency.getData(process.env.FIXER_KEY).then((data) => {
          var newExchange = new Exchange(data);
          newExchange.save().then((doc) => {
            // Add decoration to added document if necessary
            //...
            debug.add('New exchange rate added and sent back!');
            res.send(doc);
          }, (e) => {
            debug.add('Error saving the new exchange rates!');
            res.status(400).send(e);
          });
        }, (errorMessage) => {
          debug.add('Error getting exchange rates. Old value is returned!');
          debug.add(errorMessage);
          res.send(recentExchange);
          //res.send(errorMessage);
        });
      }
    } else {
      currency.getData(process.env.FIXER_KEY).then((data) => {
        var newExchange = new Exchange(data);
        newExchange.save().then((doc) => {
          // Add decoration to added document if necessary
          //...
          debug.add('First exchange rate added!');
          res.send(doc);
        }, (e) => {
          debug.add('Error saving the first exchange rates!');
          res.status(400).send(e);
        });
      }, (errorMessage) => {
        // Respond with appropriate error message
        //...
        debug.add('Error getting the first exchange rates!');
        res.status(400).send(errorMessage);
      });
    }
  }, (e) => {
    res.status(404).send(e);
  });
});

app.listen(process.env.PORT, () => {
  console.log(`Server is up on port ${process.env.PORT}`);
});

module.exports = {app, debug};
