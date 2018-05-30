module.exports = function(app, debug, User) {

  app.post('/adduser', (req, res) => {
    var body = _.pick(req.body, ['email', 'password']);
    var user = new User(body);

    user.save().then((user) => {
      res.send(user);
    }).catch((e) => {
      res.status(400).send(e);
    })
  });

}
