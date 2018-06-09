var config = require('./config/config');
const yargs = require('yargs');
const currency = require('./currency');
var {mongoose} = require('./mongoose');
var {Exchange} = require('./models/exchange');


const argv = yargs
  .command('rates', 'Update the exchange rates')
  .help()
  .argv;
var command = argv._[0];

if (command === 'rates') {

  currency.getData(process.env.FIXER_KEY).then((data) => {
    data.source = "cli";

    var exchange = new Exchange(data);
    exchange.save().then((doc) => {
      //console.log(JSON.stringify(doc, undefined, 4));
      console.log('Exchange rates saved!');
      mongoose.connection.close();
    }, (e) => {
      console.log('Error saving the exchange rates!');
      mongoose.connection.close();
    });
  }, (errorMessage) => {
    console.log('Error getting the exchange rates!');
    mongoose.connection.close();
  });

} else {

  console.log('Command not recognized');
  mongoose.connection.close();

}

/*
exchange.save().then((doc) => {
  console.log(JSON.stringify(doc, undefined, 4));
}, (e) => {
  console.log('Error saving the exchange rates!');
});
*/
