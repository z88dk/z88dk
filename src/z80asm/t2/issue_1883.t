#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

# z80asm: C_LINE directive filename clause can't start with a digit
# https://github.com/z88dk/z88dk/issues/1883

path("$test.dir")->mkpath;
path("$test.dir/00main.c")->spew(<<END_C);
int main() { }
END_C

run_ok("zcc +test -v --list $test.dir/00main.c");
run_ok("grep MODULE $test.dir/00main.c.lis");

path("$test.dir")->remove_tree if Test::More->builder->is_passing;

unlink_testfiles;
done_testing;
