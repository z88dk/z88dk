#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2260
# z80asm: -O with -x fails

my $test_dir = "${test}_dir";
path("${test}_dir/lib/sccz80")->mkpath;
path("${test}_dir/adt/b_array/c/sccz80")->mkpath;
spew("${test}_dir/adt/b_array/c/sccz80/b_array_append.asm", "nop");

# make .o
run_ok("z88dk-z80asm -v -d -O${test}_dir/target/rc2014/obj/sccz80 ".
	   "-x${test}_dir/lib/sccz80/rc2014 ".
	   "${test}_dir/adt/b_array/c/sccz80/b_array_append");

# use .o
run_ok("z88dk-z80asm -v -d -O${test}_dir/target/rc2014/obj/sccz80 ".
	   "-x${test}_dir/lib/sccz80/rc2014 ".
	   "${test}_dir/adt/b_array/c/sccz80/b_array_append");

path($test_dir)->remove_tree if Test::More->builder->is_passing;
unlink_testfiles;
done_testing;
