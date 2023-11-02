#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# https://github.com/z88dk/z88dk/issues/2068
# z80asm - directory traversal / reference for crt0 for rc2014-8085 startups

path("${test}dir/a/b/src")->mkpath;
path("${test}dir/a/b/inc")->mkpath;

path("${test}.asm")->spew(<<END);
	include "../../../../${test}dir/a/b/inc/b.inc"
END

path("${test}dir/a/b/inc/b.inc")->spew(<<END);
	defb 1,2,3
END

capture_ok("z88dk-z80asm -b -I${test}dir/a/b/src ${test}.asm", "");
check_bin_file("${test}.bin", bytes(1,2,3));

path("${test}dir")->remove_tree;

unlink_testfiles;
done_testing;
