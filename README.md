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

`git` and `bash` are standard on almost any Unix-like environment these days,
including MacOS, but if you're on a Windows box you may need to do some work
to get those installed.

The `bats` unit testing tool for `bash` is _not_ typically installed by default and will likely need to be installed unless you're working in a lab environment where `bats` has been pre-installed.

The descriptions below will go over quite a few "basic" concepts of `bash` and the shell, but this is by no means a introductory primer. It assumes, for example, that you know how to navigate among directories with `cd` and how to use tools like `ls`.

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

There are obviously numerous ways to solve this problem; here we'll walk through one very step-by-step solution that works by running the tests, and then trying to come up with the _simplest possible thing_ that can make that test pass. Because we'll deliberately do very simple (and often clearly "wrong") things, we'll get several tests to pass in "silly" ways that later tests will force us to revisit.

## The shell script file `count_successes.sh` exists

The easiest way to fix this is to create an empty file with that name. The Unix command `touch` will do exactly that, so

```bash
touch count_successes.sh
```

should get us past that test.

## The shell script file 'count_successes.sh' is executable

The file we just created isn't typically executable by default, and we need to tell the system that we intend for it to be an executable file/script. The Unix `chmod` (change mode, which is Unix-speak for change permissions) will do that:

```bash
chmod +x count_successes.sh
```

The `+x` command line argument says that we want to add (`+`) execute (`x`) permissions to the specified file. The other types of permissions are `r` (read) and `w` (write), and we can specify these at the level of all (`a`, everyone, the default so we didn't have to explicitly list it in our command), user (`u`, i.e., you), group (`g`, people in your Unix group, which could be no one else or _everyone_ else, so use group with care), and other (`o`, anyone other than you and people in your group).

## The script runs without generating an error

It turns out that this one passes straight away without our having to do anything!

In the spirit of "the simplest thing that could possibly work", we could very reasonably just choose to move on to the next failing test. I always like knowing how to make tests fail, though, just to make sure my test framework is doing something sensible. So let's make our script something that runs, but fails.

To see it run (and do nothing) yourself, try

```bash
./count_successes.sh test_data/files.tgz
```

You need the `./` in `./count_successes.sh` because in most Unix-like systems the current directory (shorthand `.`) is _not_ in the `PATH` for security reasons. So if you just typed `count_successes.sh test_data/files.tgz`
you'd get an error of the form `bash: count_successes.sh: command not found...` because `count_successes.sh` wouldn't be anywhere on your `PATH`. Putting `./` at the front provides an absolute path, saying it needs to run the `count_successes.sh` script in the current directory (`.`) instead of looking for it in the `PATH`.

### Saying what language we're using

Before we try to make it fail, though, let's also take this opportunity to tell the system what _kind_ of script we're writing here. We can write scripts in lots of different languages; we're using `bash` here, but things like `python` and `ruby` are also quite popular. Given that, it's in our interest explicitly indicate in our script file what language we're going to use for _this_ script. This is such an important and common issue that there's a special syntax for it. If the very first line of an (executable) file has the form

```bash
#!/some/path/to/a/command
```

Then the system will start up whatever program it finds at `/some/path/to/a/command` and then "feed" it the contents of this file as the program it should execute.

The easily approach is to figure out where `bash` lives on our system with `which bash` and then add a line like:

```bash
#!/usr/bin/bash
```

to the top of our script. This has to be the very first line, the `#` has to be in the very first position in that line, and there can be no spaces between `#!` (oddly enough pronounce "shebang") and the path to the executable you want to specify.

Alternatively, if we didn't want to hardcode the location and instead wanted to use the user's `PATH` environment variable to find the executable we could instead use:

```bash
#!/usr/bin/env bash
```

You see this style a lot, and it's particularly useful if you want to allow people to use some particular version of something like Ruby that they've possibly got installed in a non-standard location. People are unlikely to have some other install of `bash`, though, so we'll go with the former option here.

### Making the test fail (and error status codes)

A simple command that should fail is something like:

```bash
ls slkdjflskjfdslkfjslfkj
```

If you execute this on the command line it should (unless you happen to have a file called `slkdjflskjfdslkfjslfkj` in this directory) fail with the message

```
ls: cannot access slkdjflskjfdslkfjslfkj: No such file or directory
```

So if we edit our script to be:

```bash
#!/usr/bin/bash

ls slkdjflskjfdslkfjslfkj
```

and run it with

```bash
./count_successes.sh
```

we should get that error message. And if we run the tests (`bats bat_tests.sh`) we should find the "The script runs without generating an error code" test failing as well.

Each command line we execute generates a result state that the shell captures and makes available to us if we want. Successful commands return a status of 0, and failed commands return non-zero status codes in some fashion deemed appropriate by the authors of the command. If we do `man ls`, for example, and page down to very near the end of the documentation, we find:

```
Exit status:
       0      if OK,
       1      if minor problems (e.g., cannot access subdirectory),
       2      if serious trouble (e.g., cannot access command-line argument).
```

If we want to see which of these two error codes (1 or 2) `ls` returns when we execute

```bash
ls slkdjflskjfdslkfjslfkj
echo $?
```

It's important to run the `echo $?` _immediately_ after the `ls` command (before something else you do replaces the return status). `$?` is a special `bash` variable that holds the return status of the previously executed shell command. `echo` essentially just "prints" the value of a string (or in this case a shell variable), so `echo $?` displays the value of the status returns by our broken `ls` command. (And, for the record, we get a 2, so not being able to find the file apparently counts as "serious trouble".)

When you're done exploring the fun of return statuses, change your script to:

```bash
#!/usr/bin/bash

ls
```

and it should pass the first three tests. The `ls` isn't really doing anything but acting as a placeholder command that is unlikely to fail. We'll replace it with something else in the next step.

## The script prints out one line of text

Odds are `ls` from the previous step generates more than one line of output, so this test probably fails.

Let's get it to pass by replacing the `ls` line with `echo`, essentially turning our script into a `bash` solution to the classic "Hello, world!" problem.

```bash
#!/usr/bin/bash

echo "Hello, world!"
```

If you want to see your script generate this friendly greeting run it with:

```bash
./count_successes.sh
```

If you re-run our tests (`bats bats_tests.sh`) you should find that the first four tests now pass.

## The script prints out a line with the right form

We're currently printing "Hello, world!", when what we desire is something of the form 

```
There were XXX successes and YYY failures.
```

So let's change our `echo` command to print a line having that form:

```bash
#!/usr/bin/bash

echo "There were 82 successes and 523 failures."
```

I picked 82 and 523 entirely at random here. Any natural numbers ought to pass the test.

## The script prints out a line with the correct number of successes

Oh, it turns out that 82 apparently isn't the correct number of successes. Now we have several options:

* We could actually do something with the tarball specified on the command line and try to make real progress on the problem.
* We could look in the test script and find out what the right answer is (78, it turns out) and hack that into our `echo` line.

The second option may seem pretty silly (at best) or like a kind of cheating (at worst), but in test-driven development it's entirely legit. The idea in TDD is that we really shouldn't do anything that isn't driven by a test, and so far nothing in the tests really prevent us from just hacking 78 into our `echo` line.

So let's do it:

```bash
#!/usr/bin/bash

echo "There were 78 successes and 523 failures."
```

## The script prints out a line with the correct number of failures

In the spirit of our previous "solution", we can again just hack in the right number (22):

```bash
#!/usr/bin/bash

echo "There were 78 successes and 22 failures."
```

## The script prints the correct output for 'files.tgz'

Hey, this already passes! Sure, it passes because we hacked in the right values for `files.tgz`, but it passes. So we'll move on to the next (and final) test.

## Script prints the correct output for 'second_file_set.tgz'

And here is where we have the pay the piper and actually write a script the truly solves the problem. We could just hack in the right answers for `second_file_set.tgz`, but that would break the tests for `files.tgz`, so to get them both to pass we really have to get the script to do the work outlined in the problem statement.

Repeating the sketch of a solution from (way) up above:

* Create a temporary directory where it can do the required work.
* Extract the contents of the tarball into that directory.
* Use `grep` and `wc -l` to count the number of "SUCCESS" and "FAILURE" files
* Delete the temporary directory (so we don't clutter up the place)
* Print the results

### Create (and delete) a temporary scratch directory

This could be kind of a pain, but happily it turns out that so many scripts need scratch space like we do that there's a Unix command for just this purpose. The `mktemp` command creates a temporary file in whatever is the "standard" location for temporary files, and which is guaranteed to no conflict with any existing files there. Adding the `--directory` flag creates a directory instead of a file, which is what we want. Thus

```bash
mktemp --directory
```

will create the scratch directory we need. But we also need to capture the name of that scratch directory so we can refer to it later in our script. The obvious solution is to assign the value it returns to a variable in our script, so we might think that something like:

```bash
SCRATCH=mktemp --directory
```

might do the trick. It won't, though. That actually assigns the string `"mktemp"` to the variable `SCRATCH` and then complains that `--directory` isn't a command of its own. What we have to do is use the fact that in the shell surrounding a command with backpacks will cause the command to be executed and what it returns to be placed (as a string) where the backticked expression was. So what we really want is:

```bash
SCRATCH=`mktemp --directory`
```

This will capture the directory name returned by `mktemp` and assign it to our shell variable `SCRATCH`.

We also want to make sure that we delete our scratch directory at the end of script, which we can do with `rm -rf $SCRATCH`. The `-r` flag says to _recurse_ through the directory structure starting at `$SCRATCH` so we get any files, directories, sub-directories, etc., that were in `$SCRATCH`. The `-f` flag _forces_ `rm` to delete everything without asking us for any feedback; by default `-r` is interactive and will ask us about every file it finds, one at a time. `rm -rf` is quite dangerous and should be used with considerable caution; you could use it to delete all the contents of your home directory in one small command, for example, which would obviously be a Very Bad Thing. Here, however, it's a reasonable choice. We created `$SCRATCH` at the beginning of the script, and there shouldn't be anything there that we want to persist after this script finishes.

So let's change our script to this:

```bash
#!/usr/bin/bash

SCRATCH=`mktemp -d`

...

rm -rf $SCRATCH
```

where we'll need to replace the `...` part with the code that does the extracting, counting, and printing.

### Extract the contents of the compressed tarball

The name of the compressed `tar` file we're supposed to extract files from is provided on the command line. Inside the script we can get at the command line arguments using the syntax `$1`, `$2`, `$3`, etc., for the first, second, third, etc., command line arguments. We could just refer to `$1` throughout our script, but it's often helpful to give command line arguments more "meaningful" names by assigning them to variables like `tar_file=$1`.

Now that we know where our `tar` file is, we need to extract the contents. This comes up often enough it's worth just memorizing this pattern: `tar -zxf <filename>`. The `-z` flag says to uncompress the `tar` file on the fly as part of extracting the files; `z` is a mnemonic for `gzip`, which is the compression algorithm being used. The `-x` flag says to _extract_ all the files from the archive; you can also add a `-v` (_verbose_) if you want to see the names of the files as they're being extracted. The `-f` flag says that the next command line argument will be the name of the _file_ that contains the archive.

So `tar -zxf $tar_file` would extract all the files. But it would leave them scattered all over whatever directory we were in when we executed the `tar` command. We want to extract them all into the nice scratch directory we made so we don't clash with other things. Happily `tar` has a command line argument that lets you specify where you want to extract things to: either `-C` or `--directory`. Thus the command:

```bash
tar -zxf $tar_file --directory=$SCRATCH
```

will extract all the files from the given compressed `tar` file, putting them all in our temporary scratch directory.

### Counting successes and failures

Now we have all the files extracted into our scratch directory, so we need to count how many contain the word "SUCCESS" and how many contain the word "FAILURE". `grep` is a really useful tool for identifying lines in a file that match a pattern, or in this case files that have a line matching a pattern. In particular

```bash
grep -l <pattern> <file1> <file2> <file3> …
```

will return just the names of files that have at least one line that matches the given pattern. We don't really want to have to list all the file names, though; happily the `-r` flag tells `grep` to look _recursively_ through directories, sub-directories, etc.. Thus we can use

```bash
grep -r -l <pattern> $SCRATCH
```

to generate a list of all the files in `$SCRATCH` that have a line matching the given pattern.

Now the trick is that we need to _count_ how many files match. An easy way to do that is to use `wc -l`. `wc` is _word count_ and will give you the number of characters, words, and lines in a file or group of files. If you pipe the output of something like `grep` into `wc -l`, though, `wc` will return the number of lines that were passed to it. Since `grep` outputs each file name on a separate line, `wc -l` will give us exactly how many files `grep` returned.

We'll need to capture those counts in variables, which will require the use of backticks again:

```bash
num_successes=`grep -r -l "SUCCESS" $SCRATCH | wc -l`
num_failures=`grep -r -l "FAILURE" $SCRATCH | wc -l`
```

### Putting it all together (and printing out the result)

Now we actually have everything in place, and all we need to do is print out the result. `echo` will take care of that quite nicely:

```bash
echo "There were $num_successes successes and $num_failures failures."
```

Here we're using a common `bash` trick of inserting variable values (e.g., `$num_successes`) right in a string. ❗It's crucial, though, that you use double quotes (`"`) if you want this sort of string interpolation; if you use single quotes (`'`) then it won't interpolate the value of variables.

Given all that, our finished script becomes:

```bash
#!/usr/bin/bash                                                                 

SCRATCH=`mktemp -d`

tar_file=$1

tar -zxf $tar_file --directory=$SCRATCH

num_successes=`grep -r -l "SUCCESS" $SCRATCH | wc -l`
num_failures=`grep -r -l "FAILURE" $SCRATCH | wc -l`

echo "There were $num_successes successes and $num_failures failures."

rm -rf $SCRATCH
```

And _hey presto!_ – all our tests pass!
