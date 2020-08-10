#!/usr/bin/env bash

# Capture the command line argument
tgz_file="$1"

# Make a temporary "scratch" directory
SCRATCH=$(mktemp --directory)

# Extract everything from the tar file into the scratch directory.
tar -zxf "$tgz_file" --directory "$SCRATCH"

# Count the number of successes.
num_successes=$(grep -r SUCCESS "$SCRATCH" | wc -l)
# Count the number of failures.
num_failures=$(grep -r FAILURE "$SCRATCH" | wc -l)

# Clean up the scratch directory
rm -rf "$SCRATCH"

# Print the result.
echo "There were $num_successes successes and $num_failures failures."
