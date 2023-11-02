#!/usr/bin/env perl

#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/525
# z80asm: single star in path should glob into list of directories

path("${test}dir")->remove_tree;
unlink_testfiles;

path("${test}dir/a/1")->mkpath;
path("${test}dir/a/2")->mkpath;
path("${test}dir/b/1")->mkpath;
path("${test}dir/b/2")->mkpath;

path("${test}dir/a/1/a.asm")->spew("defb 1");
path("${test}dir/a/2/a.asm")->spew("defb 2");
path("${test}dir/b/1/a.asm")->spew("defb 3");
path("${test}dir/b/2/a.asm")->spew("defb 4");

unlink "${test}.bin";
capture_ok("z88dk-z80asm -b -o${test}.bin ".quote_os("${test}dir/**/*"), "");
check_bin_file("${test}.bin", bytes(1..4));

unlink "${test}.bin";
capture_ok("z88dk-z80asm -b -o${test}.bin ".quote_os("${test}dir/*/*/*.asm"), "");
check_bin_file("${test}.bin", bytes(1..4));

unlink "${test}.bin";
capture_ok("z88dk-z80asm -b -o${test}.bin ".quote_os("${test}dir/**/*.asm"), "");
check_bin_file("${test}.bin", bytes(1..4));

path("${test}dir")->remove_tree if Test::More->builder->is_passing;
unlink_testfiles;
done_testing;
