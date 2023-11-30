#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# https://github.com/z88dk/z88dk/issues/1874
# z80asm: illegal identifier swap a

my $got_zsdcc = -f "../../bin/z88dk-zsdcc$Config{_exe}";
if (!$got_zsdcc) {
    diag("z88dk-zsdcc not found, test skipped");
    ok 1;
}
elsif (!$ENV{DEVELOPER}) {
	diag "only run with DEVELOPER=1";		# fails in snapcraft tests
    ok 1;
}
else {
	path("$test.dir")->mkpath;
	spew("$test.dir/test.c", <<END_C);
char f(char a) {
	return (a >> 4);		/* translated to "swap a" */
}

int main() {
	return f(0x12);
}
END_C

	run_ok("zcc +zxn --list -o $test.dir/test $test.dir/test.c");
	ok scalar(grep {/\bswap\b/} path("$test.dir/test.c.lis")->lines), "found swap";

	run_ok("zcc +zx  --list -o $test.dir/test $test.dir/test.c");
	ok !scalar(grep {/\bswap\b/} path("$test.dir/test.c.lis")->lines), "did not found swap";

	path("$test.dir")->remove_tree if Test::More->builder->is_passing;
}

unlink_testfiles;
done_testing;
