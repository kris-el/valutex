var config = require('./config/config');
const _ = require('lodash');
const fs = require("fs");
const request = require('request');
const yargs = require('yargs');
const currency = require('./currency');
const country = require('./country');
var { mongoose } = require('./mongoose');
var { Exchange } = require('./models/exchange');

var dirs = ['./offline', './offline/flags', 'public', 'playground'];

dirs.forEach((dir) => {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir);
  }
});

var download = (uri, filename) => {
  return new Promise((resolve, reject) => {
    request.head(uri, (error, response, body) => {
      //console.log('content-type:', response.headers['content-type']);
      //console.log('content-length:', response.headers['content-length']);
      if (error) {
        reject('Unable to connect to the source! ' + uri);
      } else {
        resolve(request(uri).pipe(fs.createWriteStream(filename)));
      }
    });
  });
};

function areInTheSameDay(d1, d2) {
  return d1.getFullYear() === d2.getFullYear() &&
    d1.getMonth() === d2.getMonth() &&
    d1.getDate() === d2.getDate();
}

const argv = yargs
  .command('rates', 'Update the exchange rates')
  .command('countries', 'Get a json file with all the countries of available currencies')
  .command('flags', 'Download the flags of all the countries of available currencies')
  .command('clear', 'Clean DB historical data')
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

} else if (command === 'countries') {

  var promiseRates = new Promise(function (resolve, reject) {
    Exchange.findOne().sort({ age: -1 }).then((lastExchange) => {
      if (lastExchange) {
        resolve(lastExchange);
      } else {
        // Database empty make a request
        console.log('Rates: No data into db, get rates first...');
        reject();
      }
    });
  });
  var promiseCountries = new Promise(function (resolve, reject) {
    country.getData().then((data) => {
      resolve(data);
    }, (errorMessage) => {
      console.log('Error getting the country list!');
      reject();
      mongoose.connection.close();
    });
  });

  Promise.all([promiseRates, promiseCountries]).then(function (values) {
    var rates = values[0];
    var countries = values[1];
    countries.push({
      "countryName": "Europe",
      "flagCode": "EU",
      "currencyName": "Euro",
      "currencyCode": "EUR",
      "currencySymbol": "€"
    });

    if (rates && countries) {
      var deleted = false;
      countries.forEach((country) => {
        if (!_.has(rates.rates, country.currencyCode)) {
          if (!deleted) console.log('- Countries removed: ');
          console.log(country.countryName);
          countries.splice(countries.indexOf(country), 1);
          deleted = true;
        }
      });
      fs.writeFile(__dirname + "/../offline/countries.json", JSON.stringify(countries, undefined, 4), (err) => {
        if (err) {
          console.error(err);
          return;
        };
        console.log("- File has been created");
      });
    }
    mongoose.connection.close();
  });

} else if (command === 'flags') {

  var promiseRates = new Promise(function (resolve, reject) {
    Exchange.findOne().sort({ age: -1 }).then((lastExchange) => {
      if (lastExchange) {
        resolve(lastExchange);
      } else {
        // Database empty make a request
        console.log('Rates: No data into db, get rates first...');
        reject();
      }
    });
  });
  var promiseCountries = new Promise(function (resolve, reject) {
    country.getData().then((data) => {
      resolve(data);
    }, (errorMessage) => {
      console.log('Error getting the country list!');
      reject();
      mongoose.connection.close();
    });
  });

  var rates;
  var countries;
  Promise.all([promiseRates, promiseCountries]).then(function (values) {
    rates = values[0];
    countries = values[1];
    mongoose.connection.close();
    countries.push({
      "countryName": "Europe",
      "flagCode": "EU",
      "currencyName": "Euro",
      "currencyCode": "EUR",
      "currencySymbol": "€"
    });

    if (rates && countries) {
      countries.forEach((country) => {
        if (!_.has(rates.rates, country.currencyCode)) {
          countries.splice(countries.indexOf(country), 1);
        }
      });
      var downloadList = [];
      countries.forEach((countryFlag) => {
        var flag = countryFlag.flagCode.toLowerCase();
        var size = 64;
        downloadList.push(download(`http://www.countryflags.io/${flag}/flat/${size}.png`, __dirname + `/../offline/flags/country_${flag}_${size}.png`)
          .then(() => {
            process.stdout.write(".");
          }));
      });
      Promise.all(downloadList).then(() => {
        console.log(".");
        // END all promises
      });
    }
  });

} else if (command === 'clear') {

  Exchange.find().sort({ age: 1 }).then((rates) => {
    if (rates.length <= 2) {
      mongoose.connection.close();
      return;
    }
    for (var i = 0; i < rates.length - 1; i++) {
      console.log(rates[i].age);
    }
    console.log('Marked to delete: ');
    var prev = null;
    var idDeleteList = [];
    for (var i = 0; i < rates.length - 2; i++) {
      if (prev && areInTheSameDay(rates[i].age, prev.age)) {
        console.log(rates[i].age);
        idDeleteList.push(rates[i]._id);
      }
      prev = rates[i];
    }
    Exchange.deleteMany({ _id: { $in: idDeleteList } }, function (err) {
      console.log('Documents deleted!');
      mongoose.connection.close();
    });
  });

} else {

  console.log('Command not recognized');
  mongoose.connection.close();

}
