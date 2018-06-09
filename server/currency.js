const request = require('request');


var getData = (key) => {
  return new Promise((resolve, reject) => {
    request({
      url: `http://data.fixer.io/api/latest?access_key=${key}`,
      json: true
    }, (error, response, body) => {
      if (error) {
        reject('Unable to connect to the source!');
      } else if (body.success !== true) {
        // body.error.code body.error.type body.error.info
        // callback(body.error.info);
        reject('Input error!');
      } else {
        resolve({
          base: body.base,
          rates: body.rates
        });
      }
    });
  });
};

module.exports.getData = getData;
