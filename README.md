# Simple `git` and `bats` demo <!-- omit in toc -->

[![Bats tests](../../workflows/Bats%20tests/badge.svg)](../../actions?query=workflow%3A%22Bats+tests%22)
[![Shellcheck](../../workflows/shellcheck/badge.svg)](../../actions?query=workflow%3Ashellcheck)
(The `shellcheck` badge should be passing when you "fork" this repo, but
the `Bats test` badge will be marked as "failing" until you have successfully
implement the target script.)

This is a very simple repository (repo) that can be used to demonstrate
the basics of `git` and Github, as well as the `bats` unit testing tool
for `bash` shell scripts.

The idea here is to fork (copy) this repo, and then use the provided `bats` tests and
test-driven development (TDD) to incrementally build up a solution to a
(simple) problem.

If you're inclined there's
[a series of videos where I go through all this](https://www.youtube.com/watch?v=bnzTUy3xh9k&list=PLSAR9qWL-3y7Z--_jF7KUMUwjCwPjjJCY),
including things like `git` commits, branching, and pull requests. It's rather
lengthy, though; the whole series is over 2 hours, so I'd watch it at 1.5x
speed. :smile:

:warning: Unfortunately these videos have gotten rather out of
date, and I haven't had time to remake them. The process is still valid,
but they use tools like backticks (``) instead of better choices like `$(…)`.
The write-up below uses better practices, so it won't perfectly
match the solution in the video.

We don't explain the details of all the various tools and commands e use here.
You should definitely look these up online if you have questions or want to
learn more.

* [What we'll cover](#what-well-cover)
* [Pre-requisites](#pre-requisites)
* [Setting up the repo](#setting-up-the-repo)
  * [Fork the repo](#fork-the-repo)
  * [Enable GitHub Actions](#enable-github-actions)
  * [Add collaborators](#add-collaborators)
  * [Clone the repo on your computer](#clone-the-repo-on-your-computer)
    * [Setting up a project location](#setting-up-a-project-location)
    * [Cloning to your location](#cloning-to-your-location)
* [The problem at hand](#the-problem-at-hand)
  * [Breaking the problem down](#breaking-the-problem-down)
  * [The `bats` tests](#the-bats-tests)
* [Branches and pull requests](#branches-and-pull-requests)
* [A solution](#a-solution)
  * [The shell script file `count_successes.sh` exists](#the-shell-script-file-count_successessh-exists)
  * [The shell script file `count_successes.sh` is executable](#the-shell-script-file-count_successessh-is-executable)
  * [The script runs without generating an error](#the-script-runs-without-generating-an-error)
    * [Saying what language we're using](#saying-what-language-were-using)
    * [Making the test fail (and error status codes)](#making-the-test-fail-and-error-status-codes)
  * [The script prints out one line of text](#the-script-prints-out-one-line-of-text)
  * [The script prints out a line with the right form](#the-script-prints-out-a-line-with-the-right-form)
  * [The script prints out a line with the correct number of successes](#the-script-prints-out-a-line-with-the-correct-number-of-successes)
  * [The script prints out a line with the correct number of failures](#the-script-prints-out-a-line-with-the-correct-number-of-failures)
  * [The script prints the correct output for 'files.tgz'](#the-script-prints-the-correct-output-for-filestgz)
  * [Script prints the correct output for 'second_file_set.tgz'](#script-prints-the-correct-output-for-second_file_settgz)
    * [Create (and delete) a temporary scratch directory](#create-and-delete-a-temporary-scratch-directory)
    * [WHOA! `shellcheck` isn't happy](#whoa-shellcheck-isnt-happy)
    * [Extract the contents of the compressed tarball](#extract-the-contents-of-the-compressed-tarball)
    * [Counting successes and failures](#counting-successes-and-failures)
    * [Putting it all together (and printing out the result)](#putting-it-all-together-and-printing-out-the-result)
* [Wrapping up our pull request](#wrapping-up-our-pull-request)
* [Conclusion](#conclusion)

---

## What we'll cover

Over the course of this we'll cover (at least briefly) quite a few things:

* A little on how to use `git` and GitHub
* How to run (& read) Bats tests
* A little about some shell commands like `touch` and `chmod`
* A little about shell status codes
* How to tell a script what interpreter to use (`#!` or "shebang")
* How to access command line arguments in a shell script
* How to create and use temporary directories to reduce clutter
* How to use `$(…)` to capture the output of shell commands
* How to extract files from a compressed `tar` archive (a `.tgz` file)
* How to use `grep` to find files that contain a pattern
* How to use `wc -l` to count how many files `grep` finds
* How to use `echo` to "write" to the terminal

## Pre-requisites

This demo assumes that the computer you're working on has at least the following
installed on it:

* `git`
* `bash`
* `bats`

`git` and `bash` are standard on almost any Unix-like environment these days.
This includes MacOS, but you probably want to consider installing
[the `brew` package management tool](https://brew.sh/) to help install and
manage things (like `bats`) that Macs don't come with by default.
If you're on a Windows box installing [the Windows Subsystem
for Linux](https://docs.microsoft.com/en-us/windows/wsl/) should get you there.

[The `bats` unit testing tool](https://github.com/bats-core/bats-core) for
`bash` is _not_ typically installed by default and will likely need to be
installed unless you're working in a lab environment where `bats` has
been pre-installed. :warning: There's an old version of bats and a newer
(better) version that is often called `bats-core`. If you're trying to
install bats with a package manager, you probably want to
try `bats-core` first.

The descriptions below will go over quite a few "basic" concepts of `bash` and the shell, but this is by no means a introductory primer. It assumes, for example, that you know how to navigate among directories with `cd` and how to use tools like `ls`.

_NOTE:_ The solution described below (and in the `solution` branch) depends in
at least two places on the GNU behavior of command line
tools in ways that differ from the BSD behavior of those
tools. Since MacOS is built on BSD that solution won't
work as written on a Mac. One work-around if you're on a Mac is to [install GNU versions of the command-line tools](https://www.topbug.net/blog/2013/04/14/install-and-use-gnu-command-line-tools-in-mac-os-x/). If you're on a Linux box I would expect all this to work as is.

---

## Setting up the repo

You'll need to start by getting your own copy of the repository, both on Github
and on the computer you're working on. We've included
links into GitHub's documentation for these various steps as we go.
[Atlassian's `git` tutorials](https://www.atlassian.com/git/tutorials/what-is-version-control)
are also very good; they tend to focus on BitBucket instead of Github,
but the `git` parts are all the same. If you want to learn more about `git`
and `GitHub`, [the "Background" section of this Software Design lab](https://github.com/UMM-CSci-3601/intro-to-git#background)
has links to lots of resources.

### Fork the repo

Start by [forking this repo](https://docs.github.com/en/github/getting-started-with-github/fork-a-repo)
by clicking the "Fork" button near the top
right of the Github page for this repo. This creates a copy of the project
_on Github_ that belongs to you. You'll have full permissions on this copy so
you can change the code, add collaborators, etc.

### Enable GitHub Actions

By default when you fork a repository like we just did, GitHub disables the
associated GitHub Actions. We want to re-enable them, though, so you'll get
the the continuous integration checks that both the tests pass and that
`shellcheck` is happy.

If you click the "Actions" tab up near the top, you should see a big warning:

> Workflows aren’t being run on this forked repository

along with some info telling you that you should be careful about actions
(which are essentially executable) code that you might "inherit" through
forking. So you can trust that we haven't done anything malicious, or you
can have a look at our actions in `.github/workflows/` and have confirm that
we're not misbehaving. If you're comfortable, though, you can hit the big
green button that says:

> I understand my workflows, go ahead and enable them.

Then when you make your next commit, that will trigger GitHub Actions.

### Add collaborators

If you want to work on this with as a group and want other folks to have the
ability to push commits to the repo on GitHub, then you want to
[add those other folks as collaborators](https://help.github.com/articles/inviting-collaborators-to-a-personal-repository/)
now. Click the "Settings" link on the Github repo page for _your fork_.
Then choose the "Collaborators & Teams" tab, and add your collaborators
as needed.

### Clone the repo on your computer

Now that you have a forked copy on Github, you want to [`clone` that so you
have a copy on the computer you'll be programming on](https://help.github.com/articles/fork-a-repo/#keep-your-fork-synced). There are essentially
two parts to this process: Setting a place for the project on your computer,
and then cloning your fork to that location.

#### Setting up a project location

You might want to spend a second thinking about where you want this to live
on your computer. If you're doing this as part of a course, for example, then
you might want to create a directory for the course.

#### Cloning to your location

Before you do the cloning, you need to have a terminal window and be in the
right location. The details of opening a terminal window vary from system to
system so we'll leave you to figure that out (or ask for a hand in doing so).
Once you're there you'll want to use the `cd` (`c`hange `d`irectory) command
to "move" to the directory where you want to put your working copy of the
project.

Once that's all done you can clone the project:

* If necessary, go back to the "home" page for your fork of the repo on Github.
* Get the clone link by clicking the big green "Code" button/dropdown menu,
  and then copying the URL in the little popup window.
* In your terminal type `git clone --recurse-submodules <url>`, where `<url>` is the
  URL that you copied from Github.

<details>
  <summary>
  :information_source: &nbsp; You usually don't need the `--recurse-submodules`
  flag to `git clone`.
  </summary>
  
  Bats uses submodules to load additional libraries,
  like `bats-file` which provides assertions about files. Our use of Bats
  here include dependence on three Bats libraries as `git` sub-modules, and
  including the `--recurse-submodules` flag ensures that those Bats
  dependencies will be properly included. Without that your tests won't run.
  See `testing/README.md` for more details.

</details>

This should clone a working copy of your fork of the repo onto your computer.
You should probably confirm that you got the directories and files on your
computer that you see in the project on Github. If all that looks good, you
should be able to start working on the problem.

---

## The problem at hand

The goal here is to write a `bash` shell script called `count_successes.sh` that takes
a single command line
argument that is a compressed `tar` file (a "tarball" in the vernacular). Thus
a call would look something like:

```bash
./count_successes.sh loads_of_files.tgz
```

That tarball will contain a collection of files, some of which contain the
word "SUCCESS" and some of which contain the word "FAILURE". Your script should
count the successes and failures and print out:

```english
There were XXX successes and YYY failures.
```

where `XXX` and `YYY` should be the actual number of files containing "SUCCESS"
or "FAILURE".

If it helps, imagine you've been approached by a researcher that has
been doing numerous replications of some experiment. A piece of
their lab equipment checks the final result and generates these files that
contain either the world "SUCCESS" or "FAILURE". Your colleague would like you
to write a script to count those for them.

### Breaking the problem down

Given the tarball as a command line argument, your script should:

* Create a temporary directory where it can do the required work. :eyes: **This is
  important to ensure that you don't end up intermingling the files in the
  tarball with other files, corrupting the results.** It's also nice because
  then you can delete it when you're done, leaving no clutter behind to annoy others.
* Extract the contents of the tarball into that directory.
* Use `grep` and `wc -l` to count the number of "SUCCESS" and "FAILURE" files
* Delete the temporary directory (so we don't clutter up the place)
* Print the results

### The `bats` tests

To help structure the work, we've taken the set of goals in the previous section
and implemented them as specific tests in a `bats` test file. Initially all the
`bats` tests will fail because you haven't even started on the task yet, but
they can be valuable in helping guide you to a solution. If at each point you
run the tests and then focus
on how to make the _next_ failing test pass, they should lead you in a fairly
direct way to the solution.

Assuming `bats` is installed on the machine you're working on, you can run the tests via:

```bash
bats bats_tests.sh
```

`bats` generates two kinds of output, one for a failing test and one for a passing test. If a test fails you'll get a line like:

```bats
 ✗ The shell script file 'count_successes.sh' exists
   (from function `assert_exist' in file testing/bats-file/src/file.bash, line 48,
    in test file bats_tests.sh, line 21)
     `assert_exist "count_successes.sh"' failed

   -- file or directory does not exist --
   path : count_successes.sh
   --
```

The `✗` indicates that this test failed, and after the `✗` is the (hopefully description) label of the test from the test itself. `bats` also tells you which line had the failing test and includes the test itself. In this case the failing test is:

```bash
@test "The shell script file 'count_successes.sh' exists" {
  assert_exist "count_successes.sh"
}
```

The `@test` says that the following block is a `bats` test with the label

```english
"The shell script file 'count_successes.sh' exists"
```

The body of the test consists of a single test `assert_exist "count_successes.sh"`.
The assertion `assert_exist` is provided by the `bats-file` library, and
succeeds if there is a file with the name given, and fails if there isn't.

:memo: _You don't need to understand the tests to solve complete this example exercise._ That said, however, if a test fails and you don't know why, it might prove useful to look at the code for the test and see what it's trying to do so you can try that same thing by hand.

The file `bats_test.sh` here implements tests that check each of the following
(in this order):

1. The file `count_successes.sh` exists.
2. The file `count_successes.sh` is executable.
3. The script `count_successes.sh` runs without generating an error.
   * We arguably don't _need_ these first three tests; passing the later
     tests presumably implies all these things. Including these "basic"
     tests, though, makes it easier to use test-driven development (TDD)
     to incrementally build up a solution.
4. The script prints out a single line of output.
   * Surprisingly, this passes before we've done any work. That's because the
     error message saying `count_successes.sh` doesn't exist is exactly one
     line of text.
5. The script generates a line that has the form
   `"There were XXX successes and YYY failures."`, where `XXX` and `YYY`
   are integers.
   * This test pays no attention to the particular value of those two numbers, it just requires that there be numbers there. This test essentially catches things like misspellings of "successes" before we start worrying about getting the numbers right.
6. The script gets the number of successes right.
7. The script gets the number of failures right.
   * The previous two tests each test _one_ of the output numbers, while completely ignoring the value of other one. Again, these aren't strictly necessary, but help isolate a mistake in one of the computations which can make debugging easier.
8. The script provides the complete right answer for the `test_data/files.tgz` tarball.
9. The script provides the right answer for the `test_data/second_file_set.tgz`.
   * Without a test on a second data set, one could pass all these tests by simply printing the right answer for `test_data/files.tgz` without actually doing any work. Having tests on two data sets at least forces us to pay some attention to the command line argument.

If we can pass all of these tests, then we've probably got it right, or very
nearly so. We make no promises that these tests are _complete_, however, and
there are almost certainly ways to get them to pass that aren't "right" in
some important sense.

⚠️ There's no great way to test that you're doing the "right thing" with the
temporary scratch directory. If we let you create that directory (and we
don't know its name or location) then there's no good way for us to tell
that you _actually_ created a scratch directory and deleted it when you're
done. So the tests in `bats_tests.sh` can't really check that we've created,
used, and deleted a scratch directory "correctly", and we can't really "TDD"
that aspect of the solution.

---

## Branches and pull requests

This would be a good opportunity to practice good development and collaboration
habits like the use of
[`git` branches](https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging)
and [GitHub pull requests](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests). You can,
for example, create a branch called something like `implement-script` and
connect that with a pull request.

Commit often as you go through the solution below, probably after we get
each new test to pass. When we're all done, have a look at the pull request,
and review your solution. Even better, [request that a friend provide a
"real" review of your solution](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/requesting-a-pull-request-review)
and give you feedback on it.

---

## A solution

There are obviously numerous ways to solve this problem; here we'll walk
through one very step-by-step solution that works by going through the tests
one at a time, trying to come up with the _simplest possible thing_ that
can make each test pass. Because we'll deliberately do very simple
and often clearly "wrong") things, we'll get several tests to pass in
"silly" ways that later tests will force us to revisit.

### The shell script file `count_successes.sh` exists

The easiest way to fix this is to create an empty file with that name. The Unix command `touch` will do exactly that, so

```bash
touch count_successes.sh
```

should get us past that test.

### The shell script file `count_successes.sh` is executable

The file we just created isn't typically executable by default, and we need to tell the system that we intend for it to be an executable file/script. The Unix `chmod` (change mode, which is Unix-speak for "change permissions") will do that:

```bash
chmod +x count_successes.sh
```

The `+x` command line argument says that we want to add (`+`) execute (`x`) permissions to the specified file. The other types of permissions are `r` (read) and `w` (write), and we can specify these at the level of

* `a` for "all", i.e., everyone. This is the the default so we didn't have to explicitly list it in our command
* `u` for "user", i.e., you
* `g` for "group", i.e., people in your Unix group. Depending on your system's setup, this could be no one else or _everyone_ else or somewhere in between, so use this option with care.
* `o` for "other", i.e., anyone other than you and people in your group

### The script runs without generating an error

It turns out that this one passes straight away without our having to do anything!

To see it run (and do nothing) yourself, try

```bash
./count_successes.sh test_data/files.tgz
```

You need the `./` in `./count_successes.sh` because in most Unix-like systems
the current directory (shorthand `.`) is _not_ in the `PATH` for security
reasons. So if you just typed `count_successes.sh test_data/files.tgz`
you'd get an error of the form `bash: count_successes.sh: command not found...`
because `count_successes.sh` wouldn't be anywhere on your `PATH`. Putting `./`
at the front provides an _absolute path_, saying it needs to run the
`count_successes.sh` script in the current directory (`.`) instead of looking
for it in the `PATH`. :information_source: Unix provides `.` as a shorthand
for the current directory, no matter where you actually are in the filesystem.

In the spirit of "the simplest thing that could possibly work", we could very reasonably just choose to move on to the next failing test. I always like knowing how to make tests fail, though, just to make sure my test framework is doing something sensible. So let's make our script something that runs, but fails.

#### Saying what language we're using

Before we try to make it fail, though, let's also take this opportunity to
tell the system what _kind_ of script we're writing here. We can write
scripts in lots of different languages; we're using `bash` here, but things
like `python` and `ruby` are also quite popular. Given that, it's in our
interest to explicitly indicate in our script file what language we're
going to use for _this_ script. This is such an important and common
issue that there's a special syntax for it. If the very first line of
an (executable) file has the form

```bash
#!/some/path/to/a/command
```

Then the system will start up whatever program it finds at `/some/path/to/a/command` and then "feed" it the contents of this file as the program it should execute.

The easy approach is to figure out where `bash` lives on our system with `which bash` and then add a line like:

```bash
#!/usr/bin/bash
```

to the top of our script. This has to be the very first line, the `#` has
to be in the very first position in that line, and there can be no spaces
between `#!` (oddly enough pronounce "shebang") and the path to the
executable you want to specify.

:warning: Providing an absolute path like `/usr/bin/bash`, however, can
be problematic. First, an executable like `bash` might not be in the same
place on all systems, so your script might work on your system, but then
fail on another system where `bash` is located somewhere else.

So we instead don't want to hard-code the location, and instead use the user's
`PATH` environment variable to find the executable instead:

```bash
#!/usr/bin/env bash
```

:information_source: All systems have essentially agreed that at least the
`env` command is in `/usr/bin/env`, and then people can use that to figure
out where other commands like `bash` are.

#### Making the test fail (and error status codes)

A simple command that should fail is something like:

```bash
ls slkdjflskjfdslkfjslfkj
```

If you execute this on the command line it should fail (unless you happen to have a file called `slkdjflskjfdslkfjslfkj` in this directory :stuck_out_tongue_winking_eye:) with the message

```bash
ls: cannot access slkdjflskjfdslkfjslfkj: No such file or directory
```

So if we edit our script to be:

```bash
#!/usr/bin/env bash

ls slkdjflskjfdslkfjslfkj
```

and run it with

```bash
./count_successes.sh
```

we should get that error message. And if we run the tests (`bats bat_tests.sh`) we should find that the test labelled "The script runs without generating an error code" fails as well.

Each command line we execute generates a result state that the shell captures and makes available to us if we want. Successful commands return a status of 0, and failed commands return non-zero status codes in some fashion deemed appropriate by the authors of the command. If we do `man ls`, for example, and page down to very near the end of the documentation, we find:

```english
Exit status:
       0      if OK,
       1      if minor problems (e.g., cannot access subdirectory),
       2      if serious trouble (e.g., cannot access command-line argument).
```

To see which of these two error codes (1 or 2) `ls` returns in our example, try

```bash
ls slkdjflskjfdslkfjslfkj
echo $?
```

It's important to run the `echo $?` _immediately_ after the `ls` command (before something else you do replaces the return status). `$?` is a special `bash` variable that holds the return status of the previously executed shell command. `echo` essentially just "prints" the value of a string (or in this case a shell variable), so `echo $?` displays the value of the status returns by our broken `ls` command. (And, for the record, we get a 2, so not being able to find the file apparently counts as "serious trouble".)

When you're done exploring the fun of return statuses, change your script to:

```bash
#!/usr/bin/env bash

ls
```

and it should pass the first three tests. The `ls` isn't really doing anything but acting as a placeholder command that is unlikely to fail. We'll replace it with something else in the next step.

### The script prints out one line of text

Odds are `ls` from the previous step generates more than one line of output, so this test probably fails.

Let's get it to pass by replacing the `ls` line with `echo`, essentially turning our script into a `bash` solution to the classic "Hello, world!" problem.

```bash
#!/usr/bin/env bash

echo "Hello, world!"
```

If you want to see your script generate this friendly greeting run it with:

```bash
./count_successes.sh
```

If you re-run our tests (`bats bats_tests.sh`) you should find that the first four tests now pass.

### The script prints out a line with the right form

We're currently printing "Hello, world!", when what we desire is something of the form

```english
There were XXX successes and YYY failures.
```

So let's change our `echo` command to print a line having that form:

```bash
#!/usr/bin/env bash

echo "There were 82 successes and 523 failures."
```

I picked 82 and 523 entirely at random here. Any natural numbers ought to
pass this test.

### The script prints out a line with the correct number of successes

Oh look, it turns out that 82 apparently isn't the correct number of successes. :astonished: :woman_shrugging: :stuck_out_tongue_winking_eye:

Now we have several options:

* We could actually do something with the tarball specified on the command line and try to make real progress on the problem.
* We could look in the test script and find out what the right answer is (78, it turns out) and hack that into our `echo` line.

The second option may seem pretty silly (at best) or like a kind of cheating (at worst), but in an extreme approach to test-driven development it's entirely legit. The idea in TDD (especially when taken to the max) is that we really shouldn't do anything that isn't driven by a test, and so far nothing in the tests really prevent us from just hacking 78 into our `echo` line.

So let's do it:

```bash
#!/usr/bin/env bash

echo "There were 78 successes and 523 failures."
```

### The script prints out a line with the correct number of failures

And, unsurprisingly, 523 wasn't the correct number of failures, either. :octopus:

In the spirit of our previous "solution", we can again just hack in the right number (22):

```bash
#!/usr/bin/env bash

echo "There were 78 successes and 22 failures."
```

### The script prints the correct output for 'files.tgz'

Hey, this already passes! Yeah, but this, and several of our other tests,
pass because we hacked in the right values for `files.tgz`. Still, they do
pass, so we'll move on to the next (and final) test.

### Script prints the correct output for 'second_file_set.tgz'

And here is where we have the pay the piper and actually write a script the
truly solves the problem. We could just hack in the right answers
for `second_file_set.tgz`, but that would break the tests for `files.tgz`,
so to get them both to pass we really have to get the script to do the
work outlined in the problem statement.

Repeating the sketch of a solution from (way) up above:

* Create a temporary directory where it can do the required work.
* Extract the contents of the tarball into that directory.
* Use `grep` and `wc -l` to count the number of "SUCCESS" and "FAILURE" files
* Delete the temporary directory (so we don't clutter up the universe)
* Print the results

#### Create (and delete) a temporary scratch directory

This could be kind of a pain, but happily it turns out that so many scripts need scratch space like we do that there's a Unix command for just this purpose. The `mktemp` command creates a temporary file in whatever is the "standard" location for temporary files on that system, and which is guaranteed to no conflict with any existing files there. Adding the `--directory` flag creates a directory instead of a file, which is what we want. Thus

```bash
mktemp --directory
```

will create the scratch directory we need. But we also need to capture the name of that scratch directory so we can refer to it later in our script. The obvious solution is to assign the value it returns to a variable in our script, so we might think that something like:

```bash
SCRATCH=mktemp --directory
```

might do the trick. It won't, though. That actually assigns the string `"mktemp"` to the variable `SCRATCH` and then complains that `--directory` isn't a command of its own.

The bash `$(…)` construct, though, does exactly what we want. Anything we
put inside `$(…)` will be evaluated, and its value will be put in that place
in our expression. So we can use that to capture the value returned by `mktemp`
and assign it to our shell variable:

```bash
SCRATCH=$(mktemp --directory)
```

This will capture the directory name returned by `mktemp` and assign it to our shell variable `SCRATCH`.

We also want to make sure that we delete our scratch directory at the end of script, which we can do with `rm -rf $SCRATCH`. The `-r` flag says to _recurse_ through the directory structure starting at `$SCRATCH` so we get any files, directories, sub-directories, etc., that were in `$SCRATCH`. The `-f` flag _forces_ `rm` to delete everything without asking us for any feedback; by default `-r` is interactive and will ask us about every file it finds, one at a time. `rm -rf` is quite dangerous and should be used with considerable caution; you could use it to delete all the contents of your home directory in one small command, for example, which would obviously be a Very Bad Thing. Here, however, it's a reasonable choice. We created `$SCRATCH` at the beginning of the script, and there shouldn't be anything there that we want to persist after this script finishes.

So let's change our script to this:

```bash
#!/usr/bin/env bash

SCRATCH=$(mktemp -d)

...

rm -rf $SCRATCH
```

where we'll need to replace the `...` part with the code that does the extracting, counting, and printing.

#### WHOA! `shellcheck` isn't happy

If we run `shellcheck` on our script we find there are issues:

```bash
$ shellcheck count_successes.sh

In count_successes.sh line 7:
rm -rf $SCRATCH
       ^------^ SC2086: Double quote to prevent globbing and word splitting.

Did you mean:
rm -rf "$SCRATCH"

For more information:
  https://www.shellcheck.net/wiki/SC2086 -- Double quote to prevent globbing ...
```

GitHub Actions is also configured on this repo to run `shellcheck` when you
commit, so if you were to commit the stub above you'd find that the `shellcheck`
badge would change to failing :cry:, and if you dug around you'd find this same
error in those logs.

What this is telling us is that when we put the value of a variable like `SCRATCH`
in an expression, we ought to put it in double quotes or some bad things can
happen. I'll let you [follow the link they provide](https://www.shellcheck.net/wiki/SC2086)
for more details (and examples), but one simple example is the case that the
value of the variable is a string with a space in it, like `"my temp directory"`.
Without the quotes the `rm` command would become:

```bash
   rm -rf my temp directory
```

and the shell would read that as an attempt to delete three separate items, one
called `my`, one called `temp`, and one called `directory`.

Quoting as `shellcheck` suggests fixes that problem as the quotes hold the whole
string together and it's treated as a single argument to `rm`:

```bash
   rm -rf "my temp directory"
```

It's a good idea to regularly run `shellcheck` on your script as you go,
addressing warnings and issues along the way. `shellcheck` will strongly
encourage us to quote shell variables at several other points down the road,
for example.

#### Extract the contents of the compressed tarball

The name of the compressed `tar` file we're supposed to extract files from is provided on the command line. Inside the script we can get at the command line arguments using the syntax `$1`, `$2`, `$3`, etc., for the first, second, third, etc., command line arguments. We could just refer to `$1` throughout our script, but it's often helpful to give command line arguments more "meaningful" names by assigning them to variables like

```bash
  tar_file=$1
```

Now that we know where our `tar` file is, we need to extract its contents. This comes up often enough it's worth just memorizing this pattern:

```bash
  tar -zxf <filename>
```

The `-z` flag says to uncompress the `tar` file on the fly as part of extracting the files; `z` is a mnemonic for `gzip`, which is the compression algorithm being used. The `-x` flag says to _extract_ all the files from the archive; you can also add a `-v` (_verbose_) if you want to see the names of the files as they're being extracted. The `-f` flag says that the next command line argument will be the name of the _file_ that contains the archive.

:information_source: You can have all these as separate flags, like `tar -z -x -f`,
or you can bundle them together as `tar -zxf`. :warning: It's *crucial*, though,
that `-f` be right before the filename. That means that if you bundle them
together, it's necessary that `f` be the *last* in the last so it immediately
precedes the file name.

So `tar -zxf $tar_file` would extract all the files. But it would leave them scattered all over whatever directory we were in when we executed the `tar` command. We want to extract them all into the nice scratch directory we made so we don't clash with other things. Happily `tar` has a command line argument that lets you specify where you want to extract things to: either `-C` or `--directory`. Thus the command:

```bash
tar -zxf "$tar_file" --directory="$SCRATCH"
```

will extract all the files from the given compressed `tar` file, putting
them all in our temporary scratch directory. :memo: Note the quoting of
the shell variable values `$tar_file` and `$SCRATCH`, as suggested by
`shellcheck`.

#### Counting successes and failures

Now we have all the files extracted into our scratch directory, so we need
to count how many contain the word "SUCCESS" and how many contain the
word "FAILURE". `grep` is a really useful tool for identifying lines in a
file that match a pattern, or in this case files that have at least one
line matching a pattern. In particular

```bash
grep -l <pattern> <file1> <file2> <file3> …
```

will return _just_ the names of files that have at least one line that
matches the given pattern. We don't really want to have to provide all
the file names separately as arguments to `grep`, however;
happily the `-r` flag tells `grep` to look
_recursively_ through directories, sub-directories, etc.. Thus we can use

```bash
grep -r -l <pattern> "$SCRATCH"
```

to generate a list of all the files in `$SCRATCH` that have a line matching the given pattern.

Now the trick is that we need to _count_ how many files match. An easy way to do that is to use `wc -l`. `wc` is _word count_ and will give you the number of characters, words, and lines in a file or group of files. If you pipe the output of something like `grep` into `wc -l`, though, `wc` will return the number of lines that were passed to it. Since `grep` outputs each file name on a separate line, `wc -l` will give us exactly how many files `grep` returned.

We'll need to capture those counts in variables, which will require the
use of `$(…)` again:

```bash
num_successes=$(grep -r -l "SUCCESS" "$SCRATCH" | wc -l)
num_failures=$(grep -r -l "FAILURE" "$SCRATCH" | wc -l)
```

#### Putting it all together (and printing out the result)

Now we actually have everything in place, and all we need to do is print out the result. `echo` will take care of that quite nicely:

```bash
echo "There were $num_successes successes and $num_failures failures."
```

Here we're using a common `bash` trick of inserting variable values (e.g., `$num_successes`) right in a string. :warning: It's crucial, though, that you use double quotes (`"`) if you want this sort of string interpolation; if you use single quotes (`'`) then it won't interpolate the value of variables.

Given all that, our finished script becomes:

```bash
#!/usr/bin/env bash

tar_file=$1

SCRATCH=$(mktemp -d)

tar -zxf "$tar_file" --directory="$SCRATCH"

num_successes=$(grep -r -l "SUCCESS" "$SCRATCH" | wc -l)
num_failures=$(grep -r -l "FAILURE" "$SCRATCH" | wc -l)

echo "There were $num_successes successes and $num_failures failures."

rm -rf "$SCRATCH"
```

And _hey presto!_ – all our tests pass! :tada:

---

## Wrapping up our pull request

Assuming we've been committing to our branch as we've worked through the
solution, we should have all our work in that branch and, once pushed, as
part of the pull request on GitHub.

If we were working with other folks, this would be a good point to [request
code reviews](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/requesting-a-pull-request-review).
Since I'm working on this solo, I'll review the work myself, and make sure it
passes all the GitHub Actions checks:

* The tests pass
* There are no `shellcheck` warnings

If all those look good, I'll merge in the pull request and call it done!

## Conclusion

And there we have it – a TDD solution to developing a simple shell script
using the Bats testing tool for `bash`. We've learned quite a few things:

* A little on how to use `git` and GitHub
* How to run (& read) Bats tests
* A little about some shell commands like `touch` and `chmod`
* A little about shell status codes
* How to tell a script what interpreter to use (`#!` or "shebang")
* How to access command line arguments in a shell script
* How to create and use temporary directories to reduce clutter
* How to use `$(…)` to capture the output of shell commands
* How to extract files from a compressed `tar` archive (a `.tgz` file)
* How to use `grep` to find files that contain a pattern
* How to use `wc -l` to count how many files `grep` finds
* How to use `echo` to "write" to the terminal

Thanks for playing along!
