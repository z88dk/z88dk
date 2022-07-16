#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/761
# z80asm: always crashes with vs2015 binaries


path("${test}dir")->mkpath;

capture_nok("z88dk-z80asm -b -I${test}dir f_not_found.asm", <<END);
error: file open: f_not_found.asm
END

path("${test}dir")->remove_tree;
unlink_testfiles;
done_testing;
