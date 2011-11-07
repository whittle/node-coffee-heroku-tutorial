(function() {
  var http, sayHello;
  http = require('http');
  sayHello = function(request, response) {
    var message;
    message = 'Hello, world!';
    response.writeHead(200, {
      'Content-Type': 'text/plain; charset=utf-8',
      'Content-Length': Buffer.byteLength(message, 'utf8')
    });
    return response.end(message, 'utf8');
  };
}).call(this);
