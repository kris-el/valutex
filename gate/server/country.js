const request = require('request');

var getData = () => {
  return new Promise((resolve, reject) => {
    request({
      url: `https://restcountries.eu/rest/v2/all`,
      json: true
    }, (error, response, body) => {
      if (error) {
        reject('Unable to connect to the source!');
      } else {
        var countries = [];
        //console.log('body');
        for (entity of body) {
          countries.push({
            countryName: entity.name,
            flagCode: entity.alpha2Code,
            currencyName: entity.currencies[0].name,
            currencyCode: entity.currencies[0].code,
            currencySymbol: entity.currencies[0].symbol
          });
        }
        resolve(countries);
      }
    });
  });
};

module.exports.getData = getData;

/*
[
	{
		country: _
		flagCode: _
		currency: _
		currencyCode: _
	}
]
*/
