#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# create a library with existing object file and -d, -O path ends in 'x'
# and source path starts with ".."

path("$test.dir")->remove_tree;
path("$test.dir/run")->mkpath;							# run from here
path("$test.dir/run/obj")->mkpath;	# object path
path("$test.dir/src")->mkpath;			# source path
path("$test.dir/src/test.asm")->spew("nop");

chdir("$test.dir/run") or die;

# first run OK
run_ok("../../z88dk-z80asm -d -Oobj/x -xout.lib -I.. src/test");
ok -f "out.lib", "library created";
ok -f "obj/src/test.o", "object file created";

# second run fails
# error: file open: obj/x/obj/src/test.o
unlink "out.lib";
run_ok("../../z88dk-z80asm -d -Oobj/x -xout.lib -I.. src/test");
ok -f "out.lib", "library created";

chdir("../..") or die;
path("$test.dir")->remove_tree;
unlink_testfiles;
done_testing;
