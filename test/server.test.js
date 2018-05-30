var fs = require('fs');
const expect = require('expect');
const request = require('supertest');

const {app, debug} = require('./../app/server');
const {Exchange} = require('./../app/models/exchange');
const {Note} = require('./../app/models/note');

const initNotes = [{
  text: 'First test note'
}, {
  text: 'Second test note'
}];

afterEach((done) => {
  debug.reset();
  done();
});
beforeEach((done) => {
  Exchange.remove({}).then(() => done());
});
beforeEach((done) => {
  Note.remove({}).then(() => {
    return Note.insertMany(initNotes);
  }).then(() => done());
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

// describe('POST /adduser', () => {
//
//   it('should create a new user', (done) => {
//     done();
//   });
//
// });

describe('GET /getrates', () => {
  function addRatesAsRecent() {
    var inputExchange = JSON.parse(fs.readFileSync(__dirname + '/dummy-data/rates.json', 'utf8'));
    inputExchange.source = "test";
    // Removing age will taken the current time
    delete inputExchange.age;
    var exchange = new Exchange(inputExchange);
    exchange.save();
  }

  function addRatesAsOld() {
    var inputExchange = JSON.parse(fs.readFileSync(__dirname + '/dummy-data/rates.json', 'utf8'));
    inputExchange.source = "test";
    var exchange = new Exchange(inputExchange);
    exchange.save();
  }

  it('should get the rates from db history', (done) => {
    addRatesAsRecent();

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
    addRatesAsOld();

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
