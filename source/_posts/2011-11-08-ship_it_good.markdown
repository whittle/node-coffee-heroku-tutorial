---
layout: post
title: "Ship it good: going live on Heroku"
date: 2011-11-08 16:12
comments: true
categories: heroku, coffeescript
---

The title at the top of this page promises Node, CoffeeScript and
Heroku, and it’s time to add the last one.

First, let’s make a quick change to the app code:

{% gist_it 3be28c2bd5e2682cd556a41fbdc9192c62635e46 app.coffee %}

All we’re doing here is to use Node’s
[`process` module](http://nodejs.org/docs/v0.6.0/api/process.html)
to access the
[local environment](http://www.manpagez.com/man/7/environ/)
and get the value of the PORT environment variable. Be aware that all
environment variables are strings, although in this case,
[`server.listen()`](http://nodejs.org/docs/v0.6.0/api/http.html#server.listen)
will accept a string or integer as a port specification.

The reason we’re doing this is because Heroku’s
[Caledon Cedar stack](http://devcenter.heroku.com/articles/cedar)
expects to pass the correct port number to bind to via the PORT
environment variable. You can test that this is working locally by
setting PORT when you run node. If you’re using a sh-style shell, you
can do the following `PORT=3081 coffee app.coffee` and get the
familiar “Hello, world!” message at
[http://localhost:3081](http://localhost:3081)
instead of on port 3080.

