(function() {
  var http = require('http');

  var say_nothing = function(request, response) {
    response.setHeader('Content-Type', 'text/plain');
    response.end();
  };

  var app = http.createServer(say_nothing);
  app.listen(3080);
})();
