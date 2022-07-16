#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# z80asm: C_LINE directive filename clause can't start with a digit
# https://github.com/z88dk/z88dk/issues/1883

path("$test.dir")->mkpath;
spew("$test.dir/00main.c", <<END_C);
int main() { }
END_C

run_ok("zcc +test --list -o $test.dir/00main $test.dir/00main.c");
ok scalar(grep {/MODULE _00main_c/} path("$test.dir/00main.c.lis")->lines), 
	"found MODULE _00main_c";

path("$test.dir")->remove_tree if Test::More->builder->is_passing;

unlink_testfiles;
done_testing;
