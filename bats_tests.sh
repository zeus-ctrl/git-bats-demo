#!/usr/bin/env bats

# A set of incremental tests that will hopefully guide you
# through the development of a simple shell script. If you
# run these tests (`bats bats_tests.sh`) and work on the
# first failing test until it passes, you should eventually
# get all the tests to pass, at which point you will hopefully
# have a working script. If you're unclear on how to deal with
# any particular passing test, search the Internet or ask a
# question! You certainly shouldn't spend more than a few minutes
# on any of these sub-tasks.

# This checks that there is a file called "count_successes.sh"
# in this directory. If this fails, it's because you haven't
# created the file, or you created it in the wrong place.
@test "The shell script file `count_successes.sh` exists" {
  [ -f "count_successes.sh" ]
}

# This checks that the a file called "count_successes.sh"
# in this directory is executable. If the previous test passes
# but this test fails, it's because you haven't set the
# permissions on the file with `chmod`.
@test "The shell script file `count_successes.sh` is executable" {
  [ -x "count_successes.sh" ]
}

# Not sure how to handle the temporary directory issue. Maybe pass it in
# as an optional second argument? But then what's to make sure they don't
# depend on it.

# This seems fairly intractable to me, which sucks.

# Maybe I require that they use a pattern which has their user name in
# it so I know where to look. But again, I want them to delete that as part of
# cleaning up after themselves, so I'm not sure how I'd ever test for that.

# Ugh.
