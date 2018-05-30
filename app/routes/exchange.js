module.exports = function(app, debug, currency, Exchange) {

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
          // Respond with appropriate error message
          //...
          debug.addError('Error getting the first exchange rates!');
          res.status(400).send(errorMessage);
        });
      }
    }, (e) => {
      res.status(404).send(e);
    });
  });

}
