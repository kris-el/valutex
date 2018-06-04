module.exports = (function(debug, authenticate) {
  'use strict';
  const _ = require('lodash');
  const routes = require('express').Router();
  var {User} = require('./models/user');
  var {Exchange} = require('./models/exchange');
  var {Note} = require('./models/note');
  const currency = require('./currency');

  var twelveHoursAgo = new Date().getTime() - (12 * 60 * 60 * 1000);
  var oneHoursAgo = new Date().getTime() - (1 * 60 * 60 * 1000);


  // user
  //-------

  routes.post('/adduser', (req, res) => {
    debug.addTitle('POST /adduser');
    var body = _.pick(req.body, ['email', 'password']);
    var user = new User(body);

    user.save().then((user) => {
      return user.generateAuthToken();
    }).then((token) => {
      res.header('x-auth', token).send(user);
    }).catch((e) => {
      debug.add(e);
      res.status(400).send(e);
    })
  });

  routes.post('/login', (req, res) => {
    var body = _.pick(req.body, ['email', 'password']);

    User.findByCredentials(body.email, body.password).then((user) => {
      return user.generateAuthToken().then((token) => {
        res.header('x-auth', token).send(user);
      });
    }).catch((e) => {
      debug.add(e);
      res.status(400).send();
    });
  });

  routes.get('/logout', authenticate, (req, res) => {
    req.user.removeToken(req.token).then(() => {
      res.status(200).send();
    }, () => {
      res.status(400).send();
    });
  });

  routes.get('/myself', authenticate, (req, res) => {
    res.send(req.user);
  });


  // notes
  //--------

  routes.post('/addnote', authenticate, (req, res) => {
    var note = new Note({
      text: req.body.input,
      _creator: req.user._id
    });

    note.save().then((doc) => {
      res.send(doc);
    }, (e) => {
      res.status(400).send(e);
    });
  });

  routes.get('/getnotes', authenticate, (req, res) => {
    Note.find({_creator: req.user._id}).then((notes) => {
      res.send({notes});
    }, (e) => {
      res.status(400).send(e);
    });
  });


  // Currency
  //-----------

  routes.get('/getrates', (req, res) => {
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
              debug.addError('Error saving the new exchange rates!');
              res.status(400).send(e);
            });
          }, (errorMessage) => {
            debug.addError('Error getting exchange rates. Old value is returned!');
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
            debug.addError('Error saving the first exchange rates!');
            res.status(400).send(e);
          });
        }, (errorMessage) => {
          // Respond with routesropriate error message
          //...
          debug.addError('Error getting the first exchange rates!');
          res.status(400).send(errorMessage);
        });
      }
    }, (e) => {
      res.status(404).send(e);
    });
  });

  return routes;
});
