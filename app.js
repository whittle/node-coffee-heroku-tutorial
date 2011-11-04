(function() {
  var http, sayHello;
  http = require('http');
  sayHello = function(request, response) {
    var message;
    return message = 'Hello, world!';
  };
}).call(this);
