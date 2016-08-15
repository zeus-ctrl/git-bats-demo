# Simple `git` and `bats` demo

This is a very simple repository (repo) that can be used to demonstrate the basics
of `git` and Github, as well as the `bats` unit testing tool for `bash` shell
scripts.

The idea here is to fork this repo, and then use the provided `bats` tests and
test-driven development (TDD) to incrementally build up a solution to a
(simple) problem.

* [Pre-requisites](#pre-requisites)
* [Setting up the repo](#setting-up-the-repo)
* [Stating the problem](#the-problem)
* [Solving the problem](#a-solution)

# Pre-requisites

This demo assumes that the computer you're working on has at least the following
installed on it:

* `git`
* `bash`
* `bats`

`git` and `bash` are standard on almost any *nix environment these days,
including MacOS, but if you're on a Windows box you may need to do some work
to get those installed.

The `bats` unit testing tool for `bash` is _not_ typically installed by default and will likely need to be installed unless you're working in a lab environment where `bats` has been pre-installed.

_NOTE:_ The solution described below (and in the `solution` branch) depends in
at least two places on the GNU behavior of command line
tools in ways that differ from the BSD behavior of those
tools. Since MacOS is built on BSD that solution won't
work as written on a Mac. One work-around if you're on a Mac is to [install GNU versions of the command-line tools](https://www.topbug.net/blog/2013/04/14/install-and-use-gnu-command-line-tools-in-mac-os-x/). If you're on a Linux box I would expect all this to work as is.

---

# Setting up the repo

You'll need to start by getting your own copy of the repository, both on Github
and on the computer you're working on. We've included
links into Github's documentation for these various steps as we go. [Atlassian's `git` tutorials](https://www.atlassian.com/git/tutorials/what-is-version-control) are also very good; they tend to focus on BitBucket instead of Github, but the `git` parts are all the same.

## Fork the repo

Start by [forking this repository](https://help.github.com/articles/fork-a-repo/#fork-an-example-repository) by clicking the "Fork" button near the top
right of the Github page for this repo. This creates a copy of the project
_on Github_ that belongs to you. You'll have full permissions on this copy so
you can change the code, add collaborators, etc.

## Add collaborators

If you have teammates for this project, [add them as collaborators](https://help.github.com/articles/inviting-collaborators-to-a-personal-repository/) now. Click
the "Settings" link on the Github repo page for _your fork_. Then choose the
"Collaborators & Teams" tab, and add your collaborators as needed.

## Clone the repo on your computer

Now that you have a forked copy on Github, you want to [`clone` that so you
have a copy on the computer you'll be programming on](https://help.github.com/articles/fork-a-repo/#keep-your-fork-synced). There are essentially
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

---

# The problem

The goal here is to write a `bash` shell script called `count_successes.sh` that takes
a single command line
argument that is a compressed `tar` file (a "tarball" in the vernacular). Thus
a call would look something like:

```bash
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

## Breaking the problem down

Given the tarball as a command line argument, your script should:

* Create a temporary directory where it can do the required work.
** This is important to ensure that you don't end up intermingling the files in the tarball with other files, corrupting the results.
** It's also nice because then you can delete it when you're done, leaving no clutter behind to annoy others.
* Extract the contents of the tarball into that directory.
* Use `grep` and `wc -l` to count the number of "SUCCESS" and "FAILURE" files
* Delete the temporary directory (so we don't clutter up the place)
* Print the results

## The `bats` tests

To help structure the work, we've taken the set of goals in the previous section
and implemented them as specific tests in a `bats` test file. Initially all the
`bats` tests will fail because you haven't even started on the task yet, but
help guide you to a solution. If at each point you run the tests and then focus
on how to make the _next_ failing test pass, they should lead you in a fairly
direct way to the solution.

Assuming `bats` is installed on the machine you're working on, you can run the tests via:

```bash
bats bats_tests.sh
```

`bats` generates two kinds of output, one for a failing test and one for a passing test. If a test fails you'll get a line like:

```
 ✗ The shell script file 'count_successes.sh' exists
   (in test file bats_tests.sh, line 17)
     `[ -f "count_successes.sh" ]' failed
```

The `✗` indicates that this test failed, and after the `✗` is the (hopefully description) label of the test from the test itself. `bats` also tells you which line had the failing test and includes the test itself. In this case the failing test is:

```bash
@test "The shell script file 'count_successes.sh' exists" {
  [ -f "count_successes.sh" ]
}
```

The `@test` says that the following block is a `bats` test with the label 

```
"The shell script file 'count_successess.sh' exists"
``` 

The body of the test consists of a single test `[ -f "count_successes.sh" ]`. The square brackets are special shell syntax that are used to indicate a test; tests are often used in things like shell `if` statements, but can be used as stand alone assertions in `bats` tests like here. In this case the test is `-f "count_successes.sh"`, which passes if there is a file (hence the `-f`) in the current directory called `count_successess.sh`.

❗ _You don't need to understand the tests to solve complete this example exercise._ That said, however, if a test fails and you don't know why, it might prove useful to look at the code for the test and see what it's trying to do so you can try that same thing by hand.

The file `bats_test.sh` here implements the following tests (in this order):

1. The file `count_successes.sh` exists.
2. The file `count_successes.sh` is executable.
3. The script `count_successes.sh` runs without generating an error.
   * We arguably don't _need_ these first three tests; passing the later tests presumably implies all these things. Including these "basic" tests, though, makes it easier to use TDD to incrementally build up a solution.
4. The script prints out a single line of output.
5. The script generates a line that has the form `There were XXX successes and YYY failures.` where `XXX` and `YYY` are integers. 
   * This test pays no attention to the particular value of those two numbers, it just requires that there be numbers there. This test essentially catches things like misspellings of "successes" before we start worrying about getting the numbers right.
6. The script gets the number of successes right.
7. The script gets the number of failures right.
   * The previous two tests each test _one_ of the output numbers, while completely ignoring the value of other one. Again, these aren't strictly necessary, but help isolate a mistake in one of the computations which can make debugging easier.
8. The script provides the complete right answer for the `test_data/files.tgz` tarball.
9. The script provides the right answer for the `test_data/second_file_set.tgz`.
   * Without a test on a second data set, one could pass all these tests by simply printing the right answer for `test_data/files.tgz` without actually doing any work. Having tests on two data sets at least forces us to pay some attention to the command line argument.

If we can pass all of these tests, then we've probably got it right, or very nearly so. We make no promises that these tests are _complete_, however, and there are almost certainly ways to get them to pass that aren't "right" in some important sense.

⚠️ There's no great way to test that you're doing the "right thing" with the temporary scratch directory. If we let you create that directory (and we don't know its name or location) then there's no good way for us to tell that you _actually_ created a scratch directory and deleted it when you're done. So the tests in `bats_tests.sh` 

---

# A solution
