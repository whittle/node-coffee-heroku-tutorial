(function() {
  var http = require('http');

  var say_hello = function(request, response) {
    var message = 'مرحبا العالم';

    response.setHeader('Content-Type', 'text/plain; charset=utf-8');
    response.setHeader('Content-Length', Buffer.byteLength(message, 'utf8'));
    response.setHeader('X-Content-Character-Count', message.length);
    response.write(message, 'utf8');
    response.end();
  };

  var app = http.createServer(say_hello);
  app.listen(3080);
})();
