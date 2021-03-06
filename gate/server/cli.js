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
var allowedLanguages = ['en', 'it', 'th', 'vi'];

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

var missingCountries = [{
  "countryName": "Europe",
  "flagCode": "EU",
  "currencyName": "Euro",
  "currencyCode": "EUR",
  "currencySymbol": "€",
  "real": true
},
{
  "countryName": "Kekistan",
  "flagCode": "KK",
  "currencyName": "Bitcoin",
  "currencyCode": "BTC",
  "currencySymbol": "₿",
  "real": false
},
{
  "countryName": "Arstotzka",
  "flagCode": "AK",
  "currencyName": "Bitcoin",
  "currencyCode": "BTC",
  "currencySymbol": "₿",
  "real": false
},
{
  "countryName": "Federeation",
  "flagCode": "FD",
  "currencyName": "Euro",
  "currencyCode": "EUR",
  "currencySymbol": "€",
  "real": false
},
{
  "countryName": "Ferengi Alliance",
  "flagCode": "FN",
  "currencyName": "Ounce of gold",
  "currencyCode": "XAU",
  "currencySymbol": "",
  "real": false
},
{
  "countryName": "Wakanda",
  "flagCode": "WK",
  "currencyName": "Bitcoin",
  "currencyCode": "BTC",
  "currencySymbol": "₿",
  "real": false
},
{
  "countryName": "Klingon",
  "flagCode": "KL",
  "currencyName": "Bitcoin",
  "currencyCode": "BTC",
  "currencySymbol": "₿",
  "real": false
}];

var countriesToRename = [
  { from: "Viet Nam", to: "Vietnam" },
  { from: "United Kingdom of Great Britain and Northern Ireland", to: "United Kingdom" },
  { from: "Macedonia (the former Yugoslav Republic of)", to: "Macedonia" },
  { from: "Lao People's Democratic Republic", to: "Laos" },
  { from: "Venezuela (Bolivarian Republic of)", to: "Venezuela" },
  { from: "United States of America", to: "United States" },
  { from: "Korea (Democratic People's Republic of)", to: "North Korea" },
  { from: "Korea (Republic of)", to: "South Korea" }
];

var setCurrencyCode = [
  { when: "Singapore", code: "SGD" },
];

var setCurrencySymbol = [
  { when: "Armenian dram", symbol: "֏" },
  { when: "Bosnia and Herzegovina", symbol: "KM" },
  { when: "Kazakhstan", symbol: "₸" },
  { when: "Turkey", symbol: "₺" },
  { when: "Uzbekistan", symbol: "лв" },
  { when: "Singapore", symbol: "S$" }
];

var flagsToRemove = ['BQ', 'BV', 'IO', 'GF', 'GP', 'HM', 'XK', 'PM', 'SJ', 'UM', 'RE', 'TF', 'GG', 'JE', 'SH', 'MF', 'SM', 'SX', 'GS', 'TV', 'VI', 'EH', 'ZW'];

function normalizeToLower(str) {
  return str.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, "");
}

function countryCompare(a, b) {
  var countryA = normalizeToLower(a.countryName);
  var countryB = normalizeToLower(b.countryName);
  if (countryA < countryB) return -1;
  if (countryA > countryB) return 1;
  return 0;
}

const argv = yargs
  .command('rates', 'Update the exchange rates')
  .command('countries', 'Get a json file with all the countries of available currencies')
  .command('merge', 'Merge country data and translations it requires "countryNames.json"')
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
    missingCountries.forEach((country) => {
      countries.push(country);
    });
    countries.sort(countryCompare);

    console.log('- Fix country names:');
    countries.forEach(function (obj) {
      countriesToRename.forEach(function (ren) {
        if (obj.countryName == ren.from) {
          console.log(obj.countryName);
          obj.countryName = ren.to;
        }
      });
      setCurrencySymbol.forEach(function (newSym) {
        if (obj.countryName == newSym.when) {
          obj.currencySymbol = newSym.symbol;
        }
      });
      setCurrencyCode.forEach(function (newCode) {
        if (obj.countryName == newCode.when) {
          obj.currencyCode = newCode.code;
        }
      });
      if (!('real' in obj)) {
        obj.real = true;
      }
    });

    var countriesToRemove = [];
    if (rates && countries) {
      var deleted = false;
      countries.forEach((country) => {
        if (!_.has(rates.rates, country.currencyCode) || (flagsToRemove.indexOf(country.flagCode) != -1)) {
          if (!deleted) console.log('- Countries removed: ');
          console.log(country.countryName);
          countriesToRemove.push(country.countryName);
          deleted = true;
        }
      });
      countries = countries.filter((cObj) => {
        return (countriesToRemove.indexOf(cObj.countryName) == -1);
      });
      var countryNames = [];
      var element = {};
      countries.forEach((country) => {
        element = {};
        element.countryName = country.countryName;
        var countryAlt = {};
        var currencyAlt = {};
        allowedLanguages.forEach((language) => {
          _.set(countryAlt, language, country.countryName);
          _.set(currencyAlt, language, country.currencyName);
        });
        _.set(element, 'countryAlt', countryAlt);
        _.set(element, 'currencyAlt', currencyAlt);
        countryNames.push(element);
      });
      fs.writeFile(__dirname + "/../offline/countries.json", JSON.stringify(countries, undefined, 4), (err) => {
        if (err) {
          console.error(err);
          return;
        };
        console.log("- countries.json has been created");
      });
      fs.writeFile(__dirname + "/../offline/countryNames.new.json", JSON.stringify(countryNames, undefined, 4), (err) => {
        if (err) {
          console.error(err);
          return;
        };
        console.log("- countryNames.json has been created");
      });
    }
    mongoose.connection.close();
  });

} else if (command === 'merge') {

  var countryNames = [];
  var countries = [];
  var countriesUN = [];
  var countriesML = [];
  try {
    countries = require(__dirname + "/../offline/countries.json") || [];
  } catch (error) {
    countries = [];
  }
  try {
    countryNames = require(__dirname + "/../offline/countryNames.json") || [];
  } catch (error) {
    countryNames = [];
  }

  if ((countries.length > 0) && (countryNames.length > 0)) {
    console.log('Start merge!');

    allowedLanguages.forEach((lang) => {
      countriesML = [];
      countries.forEach((country) => {
        countriesPartML = {};
        console.log('--- lang: '+ lang + '   --- country: '+ country.countryName);
        var translations = countryNames.find((entity) => entity.countryName === country.countryName);
        _.set(countriesPartML, 'countryIndex', country.countryName);
        //_.set(countriesPartML, 'countryNameEn', _.get(translations, 'countryAlt.en', country.countryName));
        _.set(countriesPartML, 'countryNameTr', _.get(translations, 'countryAlt.'+ lang, country.countryName));
        _.set(countriesPartML, 'countryNameNormEn', normalizeToLower(_.get(translations, 'countryAlt.en', country.countryName)));
        _.set(countriesPartML, 'countryNameNormTr', normalizeToLower(_.get(translations, 'countryAlt.'+ lang, country.countryName)));
        //_.set(countriesPartML, 'currencyNameEn', _.get(translations, 'currencyAlt.en', country.currencyName));
        _.set(countriesPartML, 'currencyNameTr', _.get(translations, 'currencyAlt.'+ lang, country.currencyName));
        _.set(countriesPartML, 'currencyNameNormEn', normalizeToLower(_.get(translations, 'currencyAlt.en', country.currencyName)));
        _.set(countriesPartML, 'currencyNameNormTr', normalizeToLower(_.get(translations, 'currencyAlt.'+ lang, country.currencyName)));
        _.set(countriesPartML, 'flagCode', country.flagCode);
        _.set(countriesPartML, 'currencyCode', country.currencyCode);
        _.set(countriesPartML, 'currencySymbol', country.currencySymbol);
        _.set(countriesPartML, 'real', country.real);
        console.log(JSON.stringify(countriesPartML, undefined, 4));
        countriesML.push(countriesPartML);
      });
      fs.writeFile(__dirname + "/../offline/countries_"+lang+".json", JSON.stringify(countriesML, undefined, 4), (err) => {
        if (err) {
          console.error(err);
          return;
        };
        console.log("- countries_"+lang+".json has been created");
      });
    });

  } else {
    console.log('No data to merge!');
    console.log('Countries: ' + countries.length);
    console.log('Country names: ' + countryNames.length);
  }
  mongoose.connection.close();

} else if (command === 'addlang') {
  // Add missing languages to countryNames.json
  //...

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
    countries.push(missingCountry);
    countries.sort(countryCompare);

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
