---
layout: post
title: "Headers and encodings: being a good web citizen"
date: 2011-10-19 16:00
comments: true
categories: [node, javascript, utf8]
---

So, in the last post we sent our very first message, but we’re not
quite doing everything we should.

[RFC 2616 §14.13](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html),
specifies that our server should be sending a `Content-Length` header
with the size of the body in octects (8-bit bytes). Fortunately,
Node can figure that out for us:

{% gist_it 8811e6c46aa910ad71420591548f1bb4aaa644eb app.js %}

Here, we used
[`Buffer.byteLength()`](http://nodejs.org/docs/v0.4.8/api/buffers.html#buffer.byteLength)
to measure the number of bytes that are going to be sent. We also made
it explicit that we wanted to do all of this in
[UTF-8](http://en.wikipedia.org/wiki/UTF-8), although both `write()`
and `byteLength()` will default to UTF-8 if we specify nothing.

Because all of the characters in our `message` are in the ASCII
set—and can therefore be represented as single bytes in UTF-8—the
result of `byteLength()` in this case is the same as the result would
be for `message.length()`: 13. We can even prove this by including a
non-standard HTTP header:

{% gist_it 4344892c97c1f4cea0a04e188ba71baf5916b631 app.js %}

However, if we include anything besides the first 128 characters of the Unicode
character set, `message.length()` will no longer give us the correct
result:

{% gist 1299915 app.js %}

Here, the usual English message has been switched with its
[Arabic equivalent](http://www.howtosayin.com/say/arabic/hello+world.html),
which has 12 characters that occupy 23 bytes on the wire, and the
headers bear that out:

    HTTP/1.1 200 OK
    Content-Type: text/plain; charset=utf-8
    Content-Length: 23
    X-Content-Character-Count: 12
    Connection: keep-alive

Something important to note is the order that we’re calling methods on the
[`http.ServerResponse`](http://nodejs.org/docs/v0.4.12/api/http.html#http.ServerResponse).
It is critical that all the headers have been set on the response
before ever calling
[`write()`](http://nodejs.org/docs/v0.4.12/api/http.html#response.write),
because `write()` flushes the headers. Similarly,
[`end()`](http://nodejs.org/docs/v0.4.12/api/http.html#response.end)
signals that the headers and body are complete as is.

Constructing the response out-of-order is instructive, in that it
produces a number of distinct failure modes:

* Placing a `setHeader()` after a `write()` produces an exception with
  the message “Can't set headers after they are sent.” If the
  exception is uncaught, it will crash the server.

* Placing a `write()` after the `end()` causes that `write()` to never
  get sent to the client.

  * If the content-length header is too long for the actual content
    sent (i.e., the `write()`s prior to the `end()`), the client will
    stall as it waits for the server to send the missing bytes.

As we wrap things up, let’s shorten our code a little bit.
[Much](http://www.codinghorror.com/blog/2007/05/the-best-code-is-no-code-at-all.html)
has
[been](http://dev.af83.com/code-liability-not-asset-part-1-3/2010/02/24)
[said](http://www.infoq.com/news/2011/05/less-code-is-better) about
keeping your code small, so I won’t harp on it:

{% gist_it 5a37ea31b0846e8ce72d853db43d2a38babb04e3 app.js %}

What we’ve done here (besides going back to English and removing the
non-standard character-count header) is to pack our remaining headers
into an object and pass them all together to
[`ServerResponse.writeHead()`](http://nodejs.org/docs/v0.4.12/api/http.html#response.writeHead).
`writeHead()` also requires an
[HTTP status code](http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html)
which should always be `200 OK` for now.

Additionally, the documentation for
[`end()`](http://nodejs.org/docs/v0.4.12/api/http.html#response.end)
specifies that as well as finalizing our response, we can also use it
as a last (and in this case only) `write()`.

All told, this only saves us two method calls, but if every time you
refactor it nets huge gains, maybe you don’t do it enough.
