(function() {
  var http = require('http');

  var say_hello = function(request, response) {
    var message = 'Hello, world!';

    response.setHeader('Content-Type', 'text/plain');
    response.write(message);
    response.end();
  };

  var app = http.createServer(say_hello);
  app.listen(3080);
})();
