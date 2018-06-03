const fs = require('fs');
const jwt = require('jsonwebtoken');
const {ObjectID} = require ('mongodb');

const {Exchange} = require('./../app/models/exchange');
const {User} = require('./../app/models/user');
const {Note} = require('./../app/models/note');

const initNotes = [{
  text: 'First test note'
}, {
  text: 'Second test note'
}];

const userId = [new ObjectID(), new ObjectID()];

const initUsers = [{
  _id: userId[0],
  email: 'validuser1@domain.com',
  password: 'validUser12345',
  tokens: [{
    access: 'auth',
    token: jwt.sign({_id: userId[0], access: 'auth'}, 'abc123').toString()
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
  var inputExchange = JSON.parse(fs.readFileSync(__dirname + '/dummy-data/rates.json', 'utf8'));
  inputExchange.source = "test";
  // Removing age will taken the current time
  delete inputExchange.age;
  var exchange = new Exchange(inputExchange);
  exchange.save();
};

const populateExchangeWithExpiredRates = () => {
  var inputExchange = JSON.parse(fs.readFileSync(__dirname + '/dummy-data/rates.json', 'utf8'));
  inputExchange.source = "test";
  var exchange = new Exchange(inputExchange);
  exchange.save();
};

module.exports = {populateNotes, initUsers, populateUsers, clearExchangeRates, populateExchangeWithFreshRates, populateExchangeWithExpiredRates};
