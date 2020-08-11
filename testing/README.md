# Bats testing support libraries

This directory holds (pointers to) several Bats support libraries
(such as `bats-file`) that are provided as
[`git` submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules).

To make sure these submodules get initialized properly when you check out the
project used the `--recurse-submodules` flag to `git clone`, i.e.,

```bash
  git clone --recurse-submodules <repo URL>
```

If you've done that successfully you should never have any need to do anything
in here.

If, however, **your Bats tests fail immediately** with a message like:

```english
❯ bats bats_tests.sh
bats: testing/bats-support/load does not exist
/usr/local/lib/bats-core/tracing.bash: line 61: BATS_STACK_TRACE: bad array subscript
 ✗
   bats warning: Executed 1 instead of expected 9 tests

9 tests, 1 failure, 8 not run
```

then you probably don't have your submodules initialized properly, probably
because you forgot the `--recurse-submodules` flag. If that happens, the
command

```bash
  git submodule update --init --recursive
```

should correctly setup all the dependencies for you.
