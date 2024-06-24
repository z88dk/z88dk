#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

spew("${test}.asm", <<END);
	macro setTOS x, y
	ld C, y
	ld B, x
	endm

	macro useSetTOS x, y
	setTOS x, y
	endm

	org 0
	useSetTOS H, L
END

capture_ok("z88dk-z80asm -b ${test}.asm", "");
check_bin_file("${test}.bin", bytes(0x4d, 0x44));

unlink_testfiles;
done_testing;
