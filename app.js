(function() {
  var http = require('http');

  var say_nothing = function(request, response) {
    response.end();
  };

  var app = http.createServer(say_nothing);
  app.listen(3080);
})();
