var debug = {
  status: true,
  msg: [{relevance: 10, text: ''}],
  show: function() {
    if(this.status) {
      //console.log('\x1b[33m%s\x1b[0m', this.msg);
      for (i=0;i<this.msg.length;i++) {
        if(this.msg[i].relevance == 1) {
          var dec1 = '*** ';
          var dec2 = ' ***';
          console.log('\x1b[35m%s\x1b[0m', '    '+dec1 + this.msg[i].text + dec2);
        }
        else {
          var dec1 = String.fromCharCode(171);
          console.log('\x1b[35m%s\x1b[0m', '    - ' + this.msg[i].text);
        }
      }
    }
  },
  addTitle: function(text) {
    this.msg.push({relevance:1, text});
  },
  add: function(text) { this.msg.push({relevance:10, text}); },
  reset: function() { this.msg = []; }
}

module.exports = {debug};
