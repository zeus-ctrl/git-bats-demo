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
@test "The shell script file 'count_successes.sh' exists" {
  [ -f "count_successes.sh" ]
}

# This checks that the a file called "count_successes.sh"
# in this directory is executable. If the previous test passes
# but this test fails, it's because you haven't set the
# permissions on the file with `chmod`.
@test "The shell script file 'count_successes.sh' is executable" {
  [ -x "count_successes.sh" ]
}

# This checks that running the script doesn't generate an error code.
@test "The script runs without generating an error code" {
  run ./count_successes.sh files.tgz
  [ "$status" -eq 0 ]
}

# This checks that the script prints out a single line, without
# worrying about what is on that line.
@test "The script prints out one line of text" {
  run ./count_successes.sh files.tgz
  [ "${#lines[@]}" -eq 1 ]
}

ANSWER_REGEX="^There were [[:digit:]]+ successes and [[:digit:]]+ failures.$"

# This checks that the script prints out a line with the right form,
# but without worrying whether the numbers are correct.
@test "The script prints out a line with the right form" {
  run ./count_successes.sh files.tgz
  [[ $output =~ $ANSWER_REGEX ]]
}

SUCCESS_REGEX="^There were 78 successes and [[:digit:]]+ failures.$"

# This checks that the script outputs the correct number of successes,
# but doesn't worry about the number of failures.
@test "The script prints out a line with the correct number of successes" {
  run ./count_successes.sh files.tgz
  [[ $output =~ $SUCCESS_REGEX ]]
}

FAILURE_REGEX="^There were [[:digit:]]+ successes and 22 failures.$"

# This checks that the script outputs the correct number of failures,
# but doesn't worry about the number of successes.
@test "The script prints out a line with the correct number of failures" {
  run ./count_successes.sh files.tgz
  [[ $output =~ $FAILURE_REGEX ]]
}
