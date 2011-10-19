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

{% gist_it 9c358846b90b2312cf2173d1bc742f708a83e265 app.js %}

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

{% gist_it 58bfbeba133701203019536ace867261f47fa080 app.js %}

However, if we include anything besides the first 128 characters of the Unicode
character set, `message.length()` will no longer give us the correct
result:

{% gist_it eb587185509ec8c2e728067d49f4ac2d5a67ec09 app.js %}

Here, the usual English message has been switched with its
[Arabic equivalent](http://www.howtosayin.com/say/arabic/hello+world.html),
which has 12 characters that occupy 23 bytes on the wire.
