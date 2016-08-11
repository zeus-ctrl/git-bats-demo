# Simple `git` and `bats` demo

This is a very simple repository (repo) that can be used to demonstrate the basics
of `git` and Github, as well as the `bats` unit testing tool for `bash` shell
scripts.

The idea here is to fork this repo, and then use the provided `bats` tests and
test-driven development (TDD) to incrementally build up a solution to a
(simple) problem.

# Pre-requisites

This demo assumes that the computer you're working on has at least the following
installed on it:
* `git`
* `bash`
* `bats`
`git` and `bash` are standard on almost any *nix environment these days,
including MacOS, but if you're on a Windows box you may need to do some work
to get those installed.

The `bats` unit testing tool for `bash` is _not_ typically standard and will
likely need to be installed unless you're working in a lab environment where
`bats` has been pre-installed.

# Setting up the repo

You'll need to start by getting your own copy of the repository, both on Github
and on the computer you're working on.

## Fork the repo

Start by forking this repository by clicking the "Fork" button near the top
right of the Github page for this repo. This creates a copy of the project
_on Github_ that belongs to you. You'll have full permissions on this copy so
you can change the code, add collaborators, etc.

## Add collaborators

If you have teammates for this project, add them as collaborators now. Click
the "Settings" link on the Github repo page for _your fork_. Then choose the
"Collaborators & Teams" tab, and add your collaborators as needed.

## Clone the repo on your computer

Now that you have a forked copy on Github, you want to `clone` that so you
have a copy on the computer you'll be programming on. There are essentially
two parts to this process: Setting a place for the project on your computer,
and then cloning your fork to that location.

### Setting up a project location

You might want to spend a second thinking about where you want this to live
on your computer. If you're doing this as part of a course, for example, then
you might want to create a directory for the course.

### Cloning to your location

Before you do the cloning, you need to have a terminal window and be in the
right location. The details of opening a terminal window vary from system to
system so we'll leave you to figure that out (or ask for a hand in doing so).
Once you're there you'll want to use the `cd` (`c`hange `d`irectory) command
to "move" to the directory where you want to put your working copy of the
project.

Once that's all done you can clone the project:
* If necessary, go back to the "home" page for your fork of the repo on Github.
* Get the clone link by clicking the green "Clone or download" button, and then copying the URL in the little popup window.
* In your terminal type `git clone <url>`, where `<url>` is the URL that you copied from Github.

This should clone a working copy of your fork of the repo onto your computer.
You should probably confirm that you got the directories and files on your
computer that you see in the project on Github. If all that looks good, you
should be able to start working on the problem.

# The problem

You're to write a `bash` shell script called `count_successes.sh` that takes
a single command line
argument that is a compressed `tar` file (a "tarball" in the vernacular). Thus
a call would look something like:
```{bash}
./count_successes.sh loads_of_files.tgz
```
That tarball will contain a collection of files, some of which contain the
word "SUCCESS" and some of which contain the word "FAILURE". Your script should
count the successe and failures and print out:

```
There were XXX successes and YYY failures.
```

where `XXX` and `YYY` should be the actual number of files containing "SUCCESS"
or "FAILURE".

If it helps, imagine you've been approached by a researcher in another field,
and they've been doing numerous replications of some experiment. A piece of
their lab equipment checks the final result and generates these files that
contain either the world "SUCCESS" or "FAILURE". Your colleague would like you
to write a script to count those for them.

# Breaking the problem down

Given the tarball as a command line argument, your script should:
* Create a temporary directory where it can do the required work.
** This is important to ensure that you don't end up intermingling the files in the tarball with other files, corrupting the results.
** It's also nice because then you can delete it when you're done, leaving no clutter behind to annoy others.
* Copy the tarball into that directory
* Extract the contents from the tarball into that directory
* Use `grep` and `wc -l` to count the number of "SUCCESS" and "FAILURE" files
* Print the results
* Delete the temporary directory when your done (so we don't clutter up the place)

# The `bats` tests

To help structure the work, we've taken the set of goals in the previous section
and implemented them as specific tests in a `bats` test file. Initially all the
`bats` tests will fail because you haven't even started on the task yet, but
help guide you to a solution. If at each point you run the tests and then focus
on how to make the _next_ failing test pass, they should lead you in a fairly
direct way to the solution.
