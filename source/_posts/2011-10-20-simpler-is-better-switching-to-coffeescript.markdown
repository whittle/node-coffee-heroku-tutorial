---
layout: post
title: "Simpler is better: switching to CoffeeScript"
date: 2011-10-20 23:41
comments: true
categories: [javascript, coffeescript]
---

At the end of the last post, we refactored the request handler method
just a little bit to make it shorter. In this post, we’re going to
tighten things up just a little bit more by compiling
[CoffeeScript](http://jashkenas.github.com/coffee-script/) into
JavaScript.

First off, we’ll rename our one existing source file from `app.js` to
`app.coffee`. Then we go in and comment out everything:

{% gist_it 723e950848902764391da05a8e5446f132a058af app.coffee %}

You can see that instead of JavaScript’s C++ and C-style comments
(`//` to the end of the line, and `/*` through `*/`, respectively),
CoffeeScript uses Ruby-style comments: `#` to the end of the line.

The next thing you might notice is that trying to run `app.coffee`
through `node` causes a syntax error on the first line. Node doesn’t
support CoffeeScript out of the box.

The easiest way to install `coffee`, the CoffeeScript compiler, is
through [NPM](http://npmjs.org/). If you don’t have NPM yet, the
installation one-liner is `curl http://npmjs.org/install.sh |
sh`. After that, installing CoffeeScript is as easy as
`npm install -g coffee-script`. (The `-g` is for global. If you leave
it out, the `coffee` command line will only be available in the
directory that you were visiting when you installed it.)

Now that you have CoffeeScript installed, you can compile `app.coffee`
using `coffee -c app.coffee` at the command line. Go ahead and try it;
I’ll wait. Once you’ve done that, you’ll get `app.js` back in that
same directory! What’s more, it’ll closely resemble the `app.js` that
we started on back in that first post:

{% gist_it e570711b3197b346f924631a3476ae70d6d9af73 app.js %}

The first fact we can glean from this output is that the `coffee`
compiler creates an enclosing scope for our app; this in turn means
that we don’t have to:

{% gist_it 5a227cef16214828fe145ff7d752f855647f95a2 app.coffee %}

After removing the enclosing scope from our app, the next thing we’ll
do is start add pieces back in, starting with requiring the `http`
module:

{% gist_it b38ce185cd21127a5f95c0feace2f5bc65517e89 app.coffee %}

Two changes here between JavaScript and CoffeeScript:

  1. In JavaScript, it is critical that variables get marked with the
     `var` keyword when they’re initially declared; otherwise they are
     automatically global in scope. In CoffeeScript, the `var` keyword
     is _never_ used (it causes a syntax error) and the compiler
     _always_ inserts it into the compiled JavaScript for you.

  2. In JavaScript, parentheses are necessary for every function
     call. In CoffeeScript, they’re optional.

Once you run `coffee -c app.coffee` again, you can see how the
CoffeeScript compiler adds the `var` declaration and parentheses back
in:

{% gist_it b38ce185cd21127a5f95c0feace2f5bc65517e89 app.js %}

Continuing to go line by line, we’ll add the `sayHello()` function
declaration back in:

{% gist_it e4ccba356c92ffcfb5b329497859109362f910a7 app.coffee %}

Functions in CoffeeScript are not declared with the `function`
declaration as in JavaScript. Instead, they are declared with the `->`
operator. Any function arguments are listed in an optional pair of
parentheses preceding the `->` operator. The body of the function,
instead of being enclosed in curly braces as in JavaScript, is
delineated using indentation:

{% gist_it 41489bc84177a174ab0eb6f788561547d3ac861c app.coffee %}

Which then compiles to:

{% gist_it 41489bc84177a174ab0eb6f788561547d3ac861c app.js %}
