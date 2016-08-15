#!/usr/bin/env bash

# The 'g' prefixes on several calls are there to force my Mac to use the GNU
# version of some of these functions where the GNU behavior is different from
# the BSD behavior that I get on a Mac.
SCRATCH=`gmktemp -d --tmpdir`

tgz_file=$1

# Extract everything from the tar file into the scratch directory.
tar -zxf $tgz_file -C $SCRATCH

# Count the number of successes.
num_successes=`grep -r SUCCESS $SCRATCH | gwc -l`
# Count the number of failures.
num_failures=`grep -r FAILURE $SCRATCH | gwc -l`

# Clean up the scratch directory
rm -rf $SCRATCH

# Print the result.
echo "There were $num_successes successes and $num_failures failures."
