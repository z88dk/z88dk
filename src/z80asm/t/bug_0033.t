#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# BUG_0033 : -d option fails if .asm does not exist
z80asm_ok("", "", "", "ld a, 3", bytes(0x3e, 3));
ok 2 == unlink("$test.asm", "$test.bin");

run_ok("z88dk-z80asm -b -d $test.asm");
check_bin_file("$test.bin", bytes(0x3e, 3));

unlink_testfiles;
done_testing;
