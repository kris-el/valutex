module.exports = function(app, db) {
  var env = process.env.NODE_ENV || 'development';
  var config = require('../config')[env];
  const currency = require('./currency');

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
    res.send('env = ' + env);
  });

  app.get('/getall', (req, res) => {
    currency.getData(config.fixer.api_key).then((data) => {
      // Save data into db
      res.send(data);
    }, (errorMessage) => {
      res.send(errorMessage);
    });
  });

}
