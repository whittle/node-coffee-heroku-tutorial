http = require 'http'

sayHello = (request, response) ->
  message = 'Hello, world!'

  response.writeHead 200,
    'Content-Type': 'text/plain; charset=utf-8'
    'Content-Length': Buffer.byteLength message, 'utf8'
  response.end message, 'utf8'

app = http.createServer sayHello
app.listen process.env.PORT || 3080
