#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# create a library with existing object file and -d, -O path ends in 'x'
# and source path starts with ".."

for (["-xout.lib", "out.lib"],
     ["-b -o../../out.bin", "out.bin"],
	 ["-o../../out.o", "out.o"]) {
	my($opts, $out_file) = @$_;
	
	path("$test.dir")->remove_tree;
	path("$test.dir/run")->mkpath;							# run from here
	path("$test.dir/run/obj")->mkpath;	# object path
	path("$test.dir/src")->mkpath;			# source path
	path("$test.dir/src/test1.asm")->spew("nop");
	path("$test.dir/src/test2.asm")->spew("nop");

	chdir("$test.dir/run") or die;

	# first run OK
	run_ok("../../z88dk-z80asm -d -Oobj/x $opts -I.. src/test1 src/test2");
	ok -f "$out_file", "$out_file created";
	ok -f "obj/src/test1.o", "obj/src/test1.o created";
	ok -f "obj/src/test2.o", "obj/src/test2.o created";

	# second run fails
	# error: file open: obj/x/obj/src/test.o
	unlink "$out_file";
	run_ok("../../z88dk-z80asm -d -Oobj/x $opts -I.. src/test1 src/test2");
	ok -f "$out_file", "$out_file created";

	chdir("../..") or die;
	path("$test.dir")->remove_tree;
}

unlink_testfiles;
done_testing;
