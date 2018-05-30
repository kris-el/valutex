module.exports = function(app) {

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

}
