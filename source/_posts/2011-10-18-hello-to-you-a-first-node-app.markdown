---
layout: post
title: "Hello to you: a first node app"
date: 2011-10-18 15:02
comments: true
categories: [node, javascript]
---

As is traditional, we’re going to get started with a hello world app,
and we’re going to take it step-by-step.

First, we create a no-op node app. (No-op, noop, and nop are short for
no operation, which is an assembly-ish way of saying that this app
doesn’t do anything.) The initial version of that file is:

{% gist_it db26a14ea44241edccb3f46e08e2a2a7a39600e9 app.js %}

What you see here is a common construction for executing code without
adding its constituent pieces to the global environment.

Once we have that local scope create, we can start adding things to it:

{% gist_it 453f1645b44c652811d13c0b1a196a1c7b72f7a6 app.js %}

The `require()` function we’re using here is [built into
Node.js](http://nodejs.org/docs/v0.4.12/api/all.html#require),
although it isn’t a Node.js-specific invention. The `require()`
function is authoritatively described by
[CommonJS’s](http://www.commonjs.org/) [Modules
spec](http://www.commonjs.org/specs/modules/1.0/), but the kernel of
it is: it takes a module identifier (e.g. `'http'`) and returns
everything the named module has exported (in this case, an object that
we’re storing into the `http` variable).

The reason we need the `http` module is so that we can do this:

{% gist_it 013450c96caabba3abeafdbccd75ec9b85ea91eb app.js %}

The object exported by the [`http`
module](http://nodejs.org/docs/v0.4.12/api/all.html#hTTP) has a method
called `createServer`, which creates an
[`http.Server`](http://nodejs.org/docs/v0.4.12/api/all.html#http.Server),
of all things. We’re going to cleverly call the server that we just
summoned into existence `app`, despite this not being much of an app
yet.

All of the source we’ve looked at so far has been executable. If
you’ve been following along and typing it into your favorite text
editor, good job! I like the cut of your jib. If you haven’t, go ahead
and do it now. I’m going to assume that you’re using a file named
`app.js` for right now, just like I am.

Also, if you haven’t already installed Node, there are [plenty of ways
to do it](https://github.com/joyent/node/wiki/Installation), although
if you’re on a Mac, I would suggest
[Homebrew](https://github.com/mxcl/homebrew).

Once you have Node installed on your machine, you can start your app
from the directory you’re working in at any time by running `node
app.js`. When you try it with any of the previous files we’ve written
so far, however, nothing seems to happen. Node barely stops to think
before it returns you back to the console again. Where’s the server we
created?

The answer is that we created a server, but we didn’t tell it to do
anything; not even that we wanted it to accept connections. Let’s try
telling it just that:

{% gist_it 55e7733b635d0fd04addfd6ad292f5f12043c6b9 app.js %}

Here we’ve instructed the server we created to listen on port 3080 of
the machine that server is being run on. If you run `node app.js` now,
you’ll notice that instead of very quickly completing, now it seems to
do nothing but very slowly. In fact, it never returns at all, just
sitting there until you kill it (control-C in most Unix shells,
including the default shell on Macs).

The other thing you might notice about your new server is that, while
it’s running, your browser can try to connect to the sever at
[http://localhost:3080](http://localhost:3080) but it also never
returns anything. So what we’ve created is exactly what it seems to
be: a server that listens, but never says anything back. Let’s dig
into that.

If you look at the [API for
`http.createServer()`](http://nodejs.org/docs/v0.4.12/api/all.html#http.createServer)
call we’re making, you’ll see that we can pass it a `requestListener`,
which is “a function which is automatically added to the 'request'
event.” That sounds just like what we’re looking for:

{% gist_it dc8ad3b70bc79cd3b046f3aac7530907fbe661c1 app.js %}

If you run this version of app.js, you’ll find that the behavior of
our server hasn’t changed at all: it still never returns
anything. Digging into the Node API again, we see that the signature
of `http.Server`’s `request` event (which you’ll recall is the event
to which `createServer` attaches the function you give it) is
`function (request, response) { }`.

A little more digging in
[`http.ServerResponse`](http://nodejs.org/docs/v0.4.12/api/all.html#http.ServerResponse)
nets us this gem: “The method, `response.end()`, MUST be called on
each response.” Let’s put this to work for us by changing
`say_nothing()`’s parameters to match `http.Server`’s `request` event
and calling `end()` on the `ServerResponse` we just exposed:

{% gist_it cc5158d5dbede2d368a043dbb5fd7616d7206cfd app.js %}

Once you have this app running, you can finally connect to it with
your web browser at
[http://localhost:3080](http://localhost:3080). The server returns a
blank page, but at least it doesn’t just spin forever.

What can we do from here? Anything we want, really: we now have a
working web server. But, as I mentioned in the beginning, I’m a
traditionalist and so we’re going to continue in the direction of
“Hello, world!”

The HTTP server that Node provides us with is intentionally low-level
and depends on us to fill in all of the details. Later on, we’ll find
ways to encapsulate this low-level behavior in a declarative,
functional matter, but for right now, we’re going to have to do things
like set the response headers ourselves.

When I run this little non-app, the headers I see on the empty
response are:

    HTTP/1.1 200 OK
    Connection: keep-alive
    Transfer-Encoding: chunked

The next crucial header we’re going to need to get our hello through
properly is the content-type:

{% gist_it 956b4d1bc98f9d60fbb3cfc732ba46ea8cb1ceca app.js %}
