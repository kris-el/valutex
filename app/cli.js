var config = require('./config/config');
const currency = require('./currency');
var {mongoose} = require('./mongoose');
var {Exchange} = require('./models/exchange');

currency.getData(process.env.FIXER_KEY).then((data) => {
  data.source = "cli";
  var newExchange = new Exchange(data);
  newExchange.save().then((doc) => {
    console.log(JSON.stringify(doc, undefined, 4));
    mongoose.connection.close();
  }, (e) => {
    console.log('Error saving the exchange rates!');
    mongoose.connection.close();
  });
}, (errorMessage) => {
  console.log('Error getting the exchange rates!');
  mongoose.connection.close();
});
