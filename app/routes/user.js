module.exports = function(app, debug, authenticate, User) {
  const _ = require('lodash');

  app.post('/adduser', (req, res) => {
    debug.addTitle('POST /adduser');
    var body = _.pick(req.body, ['email', 'password']);
    var user = new User(body);

    user.save().then((user) => {
      return user.generateAuthToken();
    }).then((token) => {
      res.header('x-auth', token).send(user);
    }).catch((e) => {
      debug.add(e.message);
      res.status(400).send(e);
    })
  });

  app.get('/users/me', authenticate, (req, res) => {
    res.send(req.user);
  });

}
