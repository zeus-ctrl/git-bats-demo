#!/usr/bin/env bats

load 'testing/bats-support/load'
load 'testing/bats-assert/load'
load 'testing/bats-file/load'

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
  assert_exist "count_successes.sh"
}

# This checks that the a file called "count_successes.sh"
# in this directory is executable. If the previous test passes
# but this test fails, it's because you haven't set the
# permissions on the file with `chmod`.
@test "The shell script file 'count_successes.sh' is executable" {
  assert_file_executable "count_successes.sh"
}

# This checks that running the script doesn't generate an error code.
@test "The script runs without generating an error code" {
  run ./count_successes.sh test_data/files.tgz
  assert_success
}

# This checks that the script prints out a single line, without
# worrying about what is on that line. Weirdly enough it passes
# initially because the error output when there's no script happens
# to have exactly one line.
@test "The script prints out one line of text" {
  run ./count_successes.sh test_data/files.tgz
  # Bats collects the output from a command executed with `run` in
  # an array called `$lines`. The `${#lines[@]}` returns the number
  # of lines lines in that array, which we assert should be 1.
  assert_equal "${#lines[@]}" 1
}

# This regular expressions capture the desired general form of the
# response, worrying about whether the particular values are correct.
ANSWER_FORM_REGEX='^There were [[:digit:]]+ successes and [[:digit:]]+ failures.$'
# This is the same as the `ANSWER_FORM_REGEX` regular expression, except
# it has the correct expected number of successes embedded in it.
SUCCESS_REGEX="^There were 78 successes and [[:digit:]]+ failures.$"
# This is the same as the `ANSWER_FORM_REGEX` regular expression, except
# it has the correct expected number of failures embedded in it.
FAILURE_REGEX="^There were [[:digit:]]+ successes and 22 failures.$"
# This is the same as the `ANSWER_FORM_REGEX` regular expression, except
# it has both the correct expected number of successes and the correct
# number of failures for `files.tgz` embedded in it.
FILE_CORRECT_OUTPUT="There were 78 successes and 22 failures."
# This is the same as the `ANSWER_FORM_REGEX` regular expression, except
# it has both the correct expected number of successes and the correct
# number of failures for `files.tgz` embedded in it.
SECOND_FILE_CORRECT_OUTPUT="There were 76 successes and 24 failures."

# This checks that the script prints out a line with the right form,
# but without worrying whether the numbers are correct.
@test "The script prints out a line with the right form" {
  run ./count_successes.sh test_data/files.tgz
  assert_output --regexp "$ANSWER_FORM_REGEX"
}

# This checks that the script outputs the correct number of successes,
# but doesn't worry about the number of failures.
@test "The script prints out a line with the correct number of successes" {
  run ./count_successes.sh test_data/files.tgz
  assert_output --regexp "$SUCCESS_REGEX"
}

# This checks that the script outputs the correct number of failures,
# but doesn't worry about the number of successes.
@test "The script prints out a line with the correct number of failures" {
  run ./count_successes.sh test_data/files.tgz
  assert_output --regexp "$FAILURE_REGEX"
}

# The final check for all the expected output for 'files.tgz'.
@test "The script prints the correct output for 'files.tgz'" {
  run ./count_successes.sh test_data/files.tgz
  assert_output "$FILE_CORRECT_OUTPUT"
}

# Checks that the script also works for 'second_file_set.tgz'.
@test "Script prints the correct output for 'second_file_set.tgz'" {
  run ./count_successes.sh test_data/second_file_set.tgz
  assert_output "$SECOND_FILE_CORRECT_OUTPUT"
}
