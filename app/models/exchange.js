var mongoose = require('mongoose');

var Exchange = mongoose.model('Exchange', {
  base: {
    type: String,
    required: true,
    trim: true,
    minlength: 1
  },
  rates: {
    type: Object,
    required: true
  }
});

module.exports = {Exchange}
