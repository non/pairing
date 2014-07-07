## pairing

### Background

I've always enjoyed pair programming. It's not for everyone but it
definitely helps keep me honest about the code I'm writing, and often
makes me vastly more productive than I would be on my own.
Unfortunately, it can be hard to pair program when your collaborators
live in another city (or country).

This project provides a script called [pair](pair) that makes it
really easy to use [Tmux](http://tmux.sourceforge.net/) to share
virtual terminals with one (or more) collaborators. My experience is
that sharing a tmux session works much better than trying to do other
kinds of screensharing (Hangouts, VNC, etc), and makes it easier for
"either side" to pick up a shared session later to continue
hacking. Using this script plus a phone call, Skype, Hangouts,
etc. provides me with a really good pairing experience.

In order to use this script, you will need a machine that all
participants can connect to via [SSH](http://www.openssh.com/) (or
some other mechanism). It could be a VPS or one of the participants'
computers. All participants must have shell access, and the ability to
run `tmux`.

### Usage

There are three basic usages:

 * `pair ls` See which pairs are available to join.
 * `pair start joe` Start a pair named *joe*.
 * `pair join joe` Join an existing pair named *joe*.

Tmux will use the smallest dimensions that support all users'
terminals, so it's a good idea to try to agree on general font/window
size ahead of time. But since it updates dynamically this is easy to
work out as you go.

This assumes that you have put the `pair` command somewhere that your
shell can find (e.g. `/usr/local/bin` or possibly `~/bin`).

I will usually leave a pair running all the time, and then use Skype,
Google hangouts, or even a phone call to be able to talk as we
hack. Leaving the pair running means either participant can easily
refer back to it.

It's worth noting that unlike "traditional" pair programming, both
developers will be able to type into the terminal (and developers can
easily switch to a web browser or different terminal to do other work
while the pair is running). People who are not currently "driving"
(typing in the pair) can track down up API questions, look up example
code, etc.

I mainly use [Emacs](http://www.gnu.org/software/emacs/), and am
including a [.tmux.conf](dot.tmux.conf) file that works well for
me. This script should be equally-useful to people who use
[Vim](http://www.vim.org/), [Nano](http://www.nano-editor.org/), or
even [Ed](https://www.gnu.org/fun/jokes/ed-msg.txt). Members of a pair
will need to agree on an editor, although it's possible to trade-off
through the day.

### Installation

The comments in [pair](pair) provide basic installation instructions,
which I will expand on here. You will probably need to be a privileged
user (e.g. root) to run these commands, or use `sudo`.

The script should work on an *nix OS. Unfortunately I have no idea how
(or if) one could get it working on Windows.

#### 1. Install tmux

If `tmux` is not already installed, your OS should allow you to do
so. Here are some example commands:

* MacOS X:
 + [Homebrew](http://brew.sh/): `brew install tmux`
 + [MacPorts](http://www.macports.org/): `port install tmux`
 + [Fink](http://www.finkproject.org/) `fink install tmux`
* Linux:
 + Debian/Ubuntu/etc: `apt-get install tmux`
 + RedHat/CentOS/Fedora/etc: `yum install tmux`

(Feel free to submit a PR with instructions other operating systems.)

#### 2. Create a *pairing* group

You will need to create a group that all users who are allowed to pair
should belong to. In the examples I've called it *pairing* but really
any name is fine as long as it is consistent.

On Linux you can do this via `groupadd pairing`.

#### 3. Add users to the *pairing* group

You'll need to add each pairing user to the group you set up. On Linux
this can be accomplished by editing `/etc/group`.

#### 4. Create *pairs* directory with appropriate permissions

We need to create an actual location to store the pair files. The
default location is `/var/run/pairs` -- you can change this by editing
the `DIR` variable in the script.

Here are the necessary commands:

```bash
mkdir /var/run/pairs
chgrp pairing /var/run/pairs
chmod 2770 /var/run/pairs
```

These commands create the directory, change the group owner to the
*pairing* group, and set the permission to ensure all group members
can create (and read) files in the directory. If you used a different
location, or group name, modify the commands accordingly.

#### 5. Install the pair script

The location you choose should be in every user's `PATH`. A good
choice might be the `/usr/local/bin` directory.

That's it!

### Known Issues

1. Setting up the script is really fiddly. I don't see an obvious way
to make it simpler, but it would be great if it was easier to get
started.

2. All members have to agree on a lot of settings: tmux meta key, tmux
key bindings, choice of editor, and terminal size/resolution are all
shared between all participants.

3. It would be nice to have instructions that work for a wider variety
of environments.

4. Using `Ctrl-q` as meta requires a small addition to the shell
configuration to disable
[XON/XOFF](http://en.wikipedia.org/wiki/Software_flow_control)
(e.g. adding `stty -ixon` to `$HOME/.bashrc`).

To expand on #4: I think everyone should do this anyway, since having
your terminal hang inexplicably when you hit `Ctrl-q` is almost never
useful to anyone (and almost no one I work with understands what has
happened). But it's true that using `Ctrl-q` as meta requires users to
recover from this situation by using `Ctrl-q q` instead of just
`Ctrl-q`.

Since no other tools/editors that I know of use `Ctrl-q` as an
important key binding it works much better than other choices, like
`Ctrl-a`, `Ctrl-b`, etc.

### Copyright and License

All code is available to you under the
[MIT license](http://opensource.org/licenses/mit-license.php), which
can also be found in the [COPYING](COPYING) file.

Copyright Erik Osheim, 2014.
