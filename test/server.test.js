const expect = require('expect');
const request = require('supertest');

const {app, debug} = require('./../app/server');
const {User} = require('./../app/models/user');
const {Exchange} = require('./../app/models/exchange');
const {Note} = require('./../app/models/note');

const {populateNotes, initUsers, populateUsers, clearExchangeRates, populateExchangeWithFreshRates, populateExchangeWithExpiredRates} = require('./seed');


beforeEach(populateUsers);
beforeEach(clearExchangeRates);
beforeEach(populateNotes);
afterEach(() => {
  debug.reset();
});


describe('POST /addnote', () => {

  it('should create a new note', (done) => {
    var input = 'Test note input';

    request(app)
      .post('/addnote')
      .send({input})
      .expect(200)
      .expect((res) => {
        expect(res.body.text).toBe(input)
      })
      .end((err, res) => {
        if(err) {
          return done(err);
        }

        Note.find({text: input}).then((notes) => {
          expect(notes.length).toBe(1);
          expect(notes[0].text).toBe(input);
          done();
        }).catch((e) => done(e));
      });
  });

  it('should not create note with invalid body data', (done) => {
    request(app)
      .post('/addnote')
      .send({})
      .expect(400)
      .end((err, res) => {
        if(err) {
          return done(err);
        }

        Note.find().then((notes) => {
          expect(notes.length).toBe(2);
          done();
        }).catch((e) => done(e))
      });
  });

});

describe('GET /getnotes', () => {

  it('should get all the notes', (done) => {
    request(app)
      .get('/getnotes')
      .expect(200)
      .expect((res) => {
        expect(res.body.notes.length).toBe(2);
      })
      .end(done);
  });

});

describe('GET /users/me', () => {

  it('should return user if authenticated', (done) => {
    request(app)
      .get('/users/me')
      .set('x-auth', initUsers[0].tokens[0].token)
      .expect(200)
      .expect((res) => {
        expect(res.body._id).toBe(initUsers[0]._id.toHexString());
        expect(res.body.email).toBe(initUsers[0].email);
      })
      .end((err, res) => {
        if(err) {
          return done(err);
        }
        debug.show();
        done();
      });
  });

  it('should return 401 if not authenticated', (done) => {
    request(app)
      .get('/users/me')
      .expect(401)
      .expect((res) => {
        expect(res.body).toEqual({});
      })
      .end((err, res) => {
        if(err) {
          return done(err);
        }
        debug.show();
        done();
      });
  });

});

describe('POST /adduser', () => {

  it('should create a new user', (done) => {
    var email = 'testaccount@server.com';
    var password = '123Test!'

    request(app)
      .post('/adduser')
      .send({email, password})
      .expect(200)
      .expect((res) => {
        expect(res.headers['x-auth']).toBeTruthy();
        expect(res.body._id).toBeTruthy();
        expect(res.body.email).toBe(email);
      })
      .end((err) => {
        if (err) {
          return done(err);
        }
        debug.show();
        User.findOne({email}).then((user) => {
          expect(user).toBeTruthy();
          expect(user.password).not.toBe(password);
          done();
        }).catch((e) => done(e));
      });
  });

  it('should return validation errors if request is ivalid', (done) => {
    var email = 'testinvalid$server:com';
    var password = '!!!';

    request(app)
      .post('/adduser')
      .send({email, password})
      .expect(400)
      .end((err) => {
        if (err) {
          return done(err);
        }
        //debug.show();
        done();
      });
  });

  it('should not create user if email is in use', (done) => {
    var email = initUsers[0].email;
    var password = '123Test!';

    request(app)
      .post('/adduser')
      .send({email, password})
      .expect(400)
      .end((err) => {
        if (err) {
          return done(err);
        }
        //debug.show();
        done();
      });
  });

});

describe('POST /login', () => {

  it('should login and return token', (done) => {
    var userId = initUsers[1]._id;
    var email = initUsers[1].email;
    var password = initUsers[1].password;

    request(app)
      .post('/login')
      .send({email, password})
      .expect(200)
      .expect((res) => {
        expect(res.headers['x-auth']).toBeTruthy();
      })
      .end((err, res) => {
        if (err) {
          return done(err);
        }

        User.findById(userId).then((user) => {
          expect(user.tokens[0]).toHaveProperty('access', 'auth');
          expect(user.tokens[0]).toHaveProperty('token', res.headers['x-auth']);
          done();
        }).catch((e) => done(e));
      });
  });

  it('should reject login invalid credentials', (done) => {
    var userId = initUsers[1]._id;
    var email = initUsers[1].email;
    var password = initUsers[1].password + '!';

    request(app)
      .post('/login')
      .send({email, password})
      .expect(400)
      .expect((res) => {
        expect(res.headers['x-auth']).not.toBeTruthy();
      })
      .end((err, res) => {
        if (err) {
          return done(err);
        }

        User.findById(userId).then((user) => {
          expect(user.tokens.length).toBe(0);
          done();
        }).catch((e) => done(e));
      });
  });

});

describe('GET /getrates', () => {

  it('should get the rates from db history', (done) => {
    populateExchangeWithFreshRates();

    request(app)
      .get('/getrates')
      .expect(200)
      .expect((res) => {
        expect(res.body.source).toBe('test')
      })
      .end((err, res) => {
        if(err) {
          return done(err);
        }
        debug.show();
        done();
      });
  });

  // Normaly disable for not consuming API request
  xit('should get the rates from API (because db is empty)', (done) => {
    request(app)
      .get('/getrates')
      .expect(200)
      .expect((res) => {
        expect(res.body.source).toBe('api')
      })
      .end((err, res) => {
        if(err) {
          return done(err);
        }
        debug.show();
        done();
      });
  });

  // Normaly disable for not consuming API request
  xit('should get the rates from API (because values are not recent)', (done) => {
    populateExchangeWithExpiredRates();

    request(app)
      .get('/getrates')
      .expect(200)
      .expect((res) => {
        expect(res.body.source).toBe('api')
      })
      .end((err, res) => {
        if(err) {
          return done(err);
        }
        debug.show();

        Exchange.find().then((exchanges) => {
          // Expected to exchange rates:
          //   First set by test
          //   Second added by API
          expect(exchanges.length).toBe(2);
          done();
        }).catch((e) => done(e))
      });
  });

});
