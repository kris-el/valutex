const jwt = require('jsonwebtoken');
const {ObjectID} = require ('mongodb');

const {Exchange} = require('./../server/models/exchange');
const {User} = require('./../server/models/user');
const {Note} = require('./../server/models/note');

var inputExchange = require('./dummy-data/rates.json');

const userId = [new ObjectID(), new ObjectID()];

const initNotes = [{
  text: 'First test note',
  _creator: userId[0]
}, {
  text: 'Second test note',
  _creator: userId[1]
}];

const initUsers = [{
  _id: userId[0],
  email: 'validuser1@domain.com',
  password: 'validUser12345',
  tokens: [{
    access: 'auth',
    token: jwt.sign({_id: userId[0], access: 'auth'}, process.env.JWT_SECRET).toString()
  }]
}, {
  _id: userId[1],
  email: 'validuser2@domain.com',
  password: 'brokenUser12345'
}];

const populateNotes = (done) => {
  Note.remove({}).then(() => {
    return Note.insertMany(initNotes);
  }).then(() => done());
};

const populateUsers = (done) => {
  User.remove({}).then(() => {
    var userList = [];
    initUsers.forEach(function(userToSave) {
      userList.push(new User(userToSave).save());
    });

    return Promise.all(userList);
  }).then(() => done());
};

const clearExchangeRates = (done) => {
  Exchange.remove({}).then(() => done());
};

const populateExchangeWithFreshRates = () => {
  var inputExchangeFresh = Object.assign({}, inputExchange);
  inputExchangeFresh.source = "test";
  delete inputExchangeFresh.age;
  var exchange = new Exchange(inputExchangeFresh);
  exchange.save();
};

const populateExchangeWithExpiredRates = () => {
  var inputExchangeExpired = Object.assign({}, inputExchange);
  inputExchangeExpired.source = "test";
  var exchange = new Exchange(inputExchangeExpired);
  exchange.save();
};

module.exports = {populateNotes, initUsers, populateUsers, clearExchangeRates, populateExchangeWithFreshRates, populateExchangeWithExpiredRates};
