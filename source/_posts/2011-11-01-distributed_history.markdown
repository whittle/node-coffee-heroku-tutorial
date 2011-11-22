---
layout: post
title: "Distributed history: setting up a Git repo"
date: 2011-11-01 18:52
comments: true
categories: heroku, git
---

In order to use Heroku in the next post, we’re going to need to have
set up our project as a Git repository.

Even if you’re not deploying to Heroku, it is critical to always have
your source code checked into a
[revision control](http://en.wikipedia.org/wiki/Version_control)
repository. Additionally, if you aren’t already using a
[distributed revision control](http://en.wikipedia.org/wiki/Distributed_revision_control)
tool like [Git](http://git-scm.com/), you’re not getting the full
advantage of revision control.

If you’re already a Git devotee, you can set up a git repo now that
just includes the `app.coffee` file we created in the last
post. That’s it, you’re done!

If you’re used to a different distributed revision control tool, good
for you. We’re going to use Git in this tutorial because that’s the
interface that Heroku exposes, but since all DVCSs that I’m aware of
share the same basic underpinnings, you should be able to follow along
easily with the step-by-step instructions one paragraph down.

If you’re not familiar with distributed revision control, I would
recommend that you put a hold on walking through this tutorial, and
spend some time [learning Git](http://git-scm.com/documentation).
Becoming intimately familiar with a distributed revision control tool
like Git will pay enormous dividends to any developer in increased
freedom and, ultimately, productivity. It’s okay—I’ll be here when
you get back.

If you haven’t yet installed Git on your machine, you should do so
now. If you’re on a Mac and have
[Homebrew](http://mxcl.github.com/homebrew) installed, just
`brew install git`. Likewise, Linux distros based on Debian can
`apt-get install git`. Otherwise, check your package manager or the
[Git downloads](http://git-scm.com/download).

Git, like most revision control systems, works best if it has a
directory to itself. Create a new directory now, and put the
`app.coffee` file we’ve been working on inside of it.

On the command line, `cd` into the directory you just created. Right
now, it’s only content should be `app.coffee`. Now, while in the
directory, run `git init`. This initializes the directory you’re in as
a Git repo by creating a `.git` directory within the repo.

If, at any time, you’d like more information about the various `git`
subcommands, they each have their own manpage. Since most shells
expect spaces to separate arguments, invoke `man` with a hyphen
between git and the subcommand, e.g. `man git-init`.

Currently, `app.coffee` is in the repo’s working tree, but hasn’t been
committed yet. In order to commit the file, we first need to add it to
the repo’s index. The command for adding things to the index is
`git add`. In order to add just the one file, it’s as easy as
`git add app.coffee`.

If you’d like to prove to yourself that the last command actually did
something, run `git status` now for a brief explanation of what’s
going on with your repo.

In the parlance of git, now that `app.coffee` has been added to the
index, it is staged for commit. You can now run `git commit` to check
it in. When you do so, an interactive editor will open, prompting you
for a commit message. (You can customize which editor using
[`git config`](http://book.git-scm.com/5_customizing_git.html).)

In non-distributed version control systems like CVS or Subversion, a
commit represents the current state of the repository, and so commit
messages are frequently written so that they describe the state the
repo is at following the commit. In Git and other DVCSs, each commit
is instead a set of diffs applied to parent commits. Because of that
difference, it’s common practice to write commit messages so that they
describe the effect of applying that commit. As such, an appropriate
commit message here might be, “Add an HTTP server that returns a
greeting.”

Once you save the commit message and/or close your editor, your
initial commit should be complete. You can see it as part of your
history using
[`git log`](http://book.git-scm.com/3_reviewing_history_-_git_log.html).

If you’d like to keep a copy of your brand new repository at
[Github](https://github.com/) or a similar service, now would be a
good time to set up the [remotes](http://gitref.org/remotes/) for it.
