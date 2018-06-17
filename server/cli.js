var config = require('./config/config');
const _ = require('lodash');
const fs = require("fs");
const yargs = require('yargs');
const currency = require('./currency');
const country = require('./country');
var {mongoose} = require('./mongoose');
var {Exchange} = require('./models/exchange');


const argv = yargs
  .command('rates', 'Update the exchange rates')
  .command('countries', 'Get a json file with all the countries of available currencies')
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

} if (command === 'countries') {

  var promiseRates = new Promise(function(resolve, reject) {
    Exchange.findOne().sort({age: -1}).then((lastExchange) => {
      if(lastExchange) {
        resolve(lastExchange);
      } else {
        // Database empty make a request
        console.log('Rates: No data into db, get rates first...');
        reject();
      }
    });
  });
  var promiseCountries = new Promise(function(resolve, reject) {
    country.getData().then((data) => {
      resolve(data);
    }, (errorMessage) => {
      console.log('Error getting the country list!');
      reject();
      mongoose.connection.close();
    });
  });

  Promise.all([promiseRates, promiseCountries]).then(function(values) {
    var rates = values[0];
    var countries = values[1];

    if(rates && countries) {
      var deleted = false;
      countries.forEach((country) => {
        if (! _.has(rates.rates, country.currencyCode)) {
          if (! deleted) console.log('- Countries removed: ');
          console.log(country.name);
          countries.splice( countries.indexOf(country), 1 );
          deleted = true;
        }
      });
      fs.writeFile(__dirname+"/../offline/countries.json", JSON.stringify(countries, undefined, 4), (err) => {
          if (err) {
              console.error(err);
              return;
          };
          console.log("- File has been created");
      });
    }
    mongoose.connection.close();
  });

} else {

  console.log('Command not recognized');
  mongoose.connection.close();

}
