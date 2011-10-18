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

{% gist_it b352d02fd451095f5c08f37cfaba874c542cfc1e app.js %}

What you see here is a common construction for executing code without
adding its constituent pieces to the global environment.
