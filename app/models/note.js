var mongoose = require('mongoose');

var Note = mongoose.model('Note', {
  text: {
    type: String,
    required: true,
    trim: true,
    minlength: 1
  }
});

module.exports = {Note}
