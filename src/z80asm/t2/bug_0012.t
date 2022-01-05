#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

# BUG_0012: binfilename[] array is too short, should be FILENAME_MAX
path("$test.asm")->spew(<<END);
		nop
END
run_ok("./z88dk-z80asm -b -o".("./" x 64)."$test.bin $test.asm");
check_bin_file("$test.bin", bytes(0));

unlink_testfiles;
done_testing;
