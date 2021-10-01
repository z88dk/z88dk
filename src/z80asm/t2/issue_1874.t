#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

# z80asm: illegal identifier swap a
# https://github.com/z88dk/z88dk/issues/1874

my $got_zsdcc = `which z88dk-zsdcc 2> /dev/null`;
if (!$got_zsdcc) {
    diag("z88dk-zsdcc not found, test skipped");
    ok 1;
}
else {
	path("$test.dir")->mkpath;
	path("$test.dir/test.c")->spew(<<END_C);
char f(char a) {
	return (a >> 4);		/* translated to "swap a" */
}

int main() {
	return f(0x12);
}
END_C

	run_ok("zcc +zxn --list $test.dir/test.c");
	run_ok("grep -w swap $test.dir/test.c.lis");

	run_ok("zcc +zx  --list $test.dir/test.c");
	run_nok("grep -w swap $test.dir/test.c.lis");

	path("$test.dir")->remove_tree;
}

unlink_testfiles;
done_testing;
