var mongoose = require('mongoose');

var Exchange = mongoose.model('Exchange', {
  source: {
    type: String,
    trim: true,
    default: "api" //[api, cli]
  },
  age: {
    type : Date,
    default: Date.now
  },
  base: {
    type: String,
    required: true,
    trim: true,
    uppercase: true,
    minlength: 1
  },
  rates: {
    type: Object,
    required: true
  }
});

module.exports = {Exchange}
