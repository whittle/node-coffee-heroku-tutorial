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

At this point, you can run `coffee -c app.coffee` again to see the
compiled code in `app.js`. Alternatively, if you’re getting tired of
running the compiler every time, you can set a separate process to do
it for you: `coffee -wc app.coffee &` will fork a new process to do
that compiling for you whenever `app.coffee` changes on the disk.

Regardless of how you compile it, once you have the new version of
`app.js`, you can see how the CoffeeScript compiler adds the `var`
declaration and parentheses back in:

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

You can see here how the indented line following the function
declaration is included in the compiled code’s function body.

More importantly, you can see how all declared variables are preceded
in the compiled code by `var` declarations in their immediately
enclosing scope, i.e. `message` is declared within `sayHello`, rather
than with `http` and `sayHello` at the top of the module.

Also notable is that `sayHello` returns `message`, despite the fact
that we didn’t explicitly declare a return in the CoffeeScript
version. Another difference between CoffeeScript and JavaScript is
that JavaScript features _explicit_ return semantics—in which
functions don’t return anything unless a `return` statement is
encountered during execution of the function—while CoffeeScript
features _implicit_ return semantics—in which every function which
completes is expected to return a value. In particular, CoffeeScript
will return the result of the last statement encountered within a
function; in this case the assignment of the string literal
`"Hello, world"` to the variable `message`.

Continuing on, we’ll add the rest of `sayHello()` back in:

{% gist_it d1058e3ad2cb4ebc6328dfd5191122975e3679f9 app.coffee %}

The only surprises here are further characters we can dispense
with. Object literals in CoffeeScript:

  1. Don’t require enclosing braces, as long as they’re indented
  properly.

  2. Don’t require separating commas, as long as each property starts
  on a new line.

Even without the extra salad, objects get compiled back into
picture-perfect JavaScript:

{% gist_it d1058e3ad2cb4ebc6328dfd5191122975e3679f9 app.js %}

Also note that, again, the last lexical line of the CoffeeScript
function is turned into an explicit return in the JavaScript function.

Let’s add in the last bit of `app.coffee`:

{% gist_it ef9f10f216173b22845748a33b9c37672eaceb07 app.coffee %}

There’s nothing really exciting to see here, we’re just removing
`var`s and parentheses. In CoffeeScript, `var` isn’t ever a valid
keyword, so don’t ever use it. Parentheses, being optional, are a
little trickier—we can see why if we combine the last two lines:

    http.createServer(sayHello).listen 3080

Here, the first set of parentheses are necessary so that we can chain
`listen()` off of the result of the call to `createServer()`, but
parentheses are unnecessary on the call to `listen()` because there is
nothing chained after the argument to `listen()`.

The big caveat to remember with parentheses comes into play when there
are no arguments. A function without arguments or parentheses is just
an object and gets passed like one and dereferenced like one. This is
the case, e.g. when we pass `sayHello` to `createServer()`. If you
need the result of a function without arguments, use empty parentheses
to indicate that it should be called like a function, not just
dereferenced like an object.

The final compiled JavaScript is just what you might expect:

{% gist_it ef9f10f216173b22845748a33b9c37672eaceb07 app.js %}

Our transition from JavaScript to CoffeeScript is complete! If you
want to check that the compiled JavaScript works the way it should,
you are welcome to compile again, then run `node app.js` just like in
previous posts. That’s two steps, though, and we’re trying to
simplify. The simpler thing to do is to combine the steps:
`coffee app.coffee` runs the file on node without creating a compiled
JavaScript file.

You might also think that this can be combined with the `-w` flag so
that the `coffee` command will watch your files and serve the current
version of the app, but on the present version (coffee-script@1.1.2),
it’s not quite that easy. We’ll plan on adding hot reloads later on.

From now on, posts are going to assume that you’re serving the
CoffeeScript files directly using `coffee`, so there won’t be any
mention of JavaScript files unless they’re of particular interest.
