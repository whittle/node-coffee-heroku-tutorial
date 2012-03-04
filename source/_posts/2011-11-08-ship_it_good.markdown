---
layout: post
title: "Ship it good: going live on Heroku"
date: 2011-11-08 16:12
comments: true
categories: heroku, coffeescript
---

The title at the top of this page promises Node, CoffeeScript and
Heroku, and it’s time to add the last one.

Heroku supports multiple interfaces, but for right now we’re going to
stick with the Command Line Interface. The CLI is built as a
[Ruby](http://www.ruby-lang.org/) [gem](http://rubygems.org/), so
first check if `ruby` and `gem` are already installed on your machine:

    % ruby --version
    ruby 1.9.2p290 (2011-07-09 revision 32553) [x86_64-darwin10.8.0]
    % gem --version
    1.8.10

If the `ruby` command isn’t found, you’ll want to install it with your
chosen package manager or from the
[source](http://www.ruby-lang.org/en/downloads/). Your Ruby
installation may come with the `gem` command or it may be packaged
separately for your distro (in Debian, the package is named
`rubygems`). If neither is the case, RubyGems can be installed
[separately](http://rubygems.org/pages/download).

Once that’s done, it’s just a matter of `gem install heroku` and you
should have the Heroku CLI at your fingertips.

The first time you run any `heroku` command, the CLI will ask you for
your email and API token. If you haven’t [signed up for an Heroku
account yet](http://www.heroku.com/signup), you will need to do so to
make it past this step.

Once you’ve acquired and entered your credentials, the next thing we
need to do now that `heroku` is installed is to set up a keypair. The
command to accomplish just that is `heroku keys:add`.

---



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

