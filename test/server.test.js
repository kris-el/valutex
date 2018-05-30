const expect = require('expect');
const request = require('supertest');

const {app} = require('./../app/server');
const {Note} = require('./../app/models/note');

beforeEach((done) => {
  Note.remove({}).then(() => done());
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

        Note.find().then((notes) => {
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
          expect(notes.length).toBe(0);
          done();
        }).catch((e) => done(e))
      });
  });

});