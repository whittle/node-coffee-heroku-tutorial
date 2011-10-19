(function() {
  var http = require('http');

  var say_nothing = function() {};

  var app = http.createServer(say_nothing);
  app.listen(3080);
})();
