var fs = require('fs');

const {ObjectID} = require ('mongodb');

const {Exchange} = require('./../app/models/exchange');
const {User} = require('./../app/models/user');
const {Note} = require('./../app/models/note');

const initNotes = [{
  text: 'First test note'
}, {
  text: 'Second test note'
}];

const populateNotes = (done) => {
  Note.remove({}).then(() => {
    return Note.insertMany(initNotes);
  }).then(() => done());
};

const populateUsers = (done) => {
  User.remove({}).then(() => done());
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

module.exports = {populateNotes, populateUsers, clearExchangeRates, populateExchangeWithFreshRates, populateExchangeWithExpiredRates};
