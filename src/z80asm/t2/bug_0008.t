#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

# BUG_0008 : code block of 64K is read as zero

# assemble, don't link
path("${test}.asm")->spew(<<END);
        defs 65536, 0xAA
END
capture_ok("./z88dk-z80asm ${test}.asm", "");

# link only
unlink "${test}.asm";
capture_ok("./z88dk-z80asm -d -b ${test}.0", "");
check_bin_file("${test}.bin", bytes((0xaa) x 65536));

unlink_testfiles;
done_testing;
