module.exports = function(app, debug, Note) {

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

}
