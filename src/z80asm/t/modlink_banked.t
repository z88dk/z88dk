#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

#------------------------------------------------------------------------------
# Test output binary files for a banked system

unlink_testfiles;

spew("${test}.asm", <<'END');
		section bank0
		org 0
		public  start0, bank_switch_0, func0

	start0:
		ret

		defs 8 - ASMPC

	bank_switch_0:
		ret

	func0:
		ret
END

spew("${test}1.asm", <<'END');
		section bank1
		org 0
		public  start1, bank_switch_1, func1
		extern  start0, func0

	start1:
		call bank_switch_1
		defw start0

		defs 8 - ASMPC

	bank_switch_1:
		ret

		nop

	func1:
		ret
END

spew("${test}2.asm", <<'END');
		section main
		org $4000
		extern  bank_switch_0, func0, bank_switch_1, func1

	main:
		call bank_switch_0
		defw func0
		call bank_switch_1
		defw func1
		ret
END

capture_ok("z88dk-z80asm -b ${test}.asm ${test}1.asm ${test}2.asm", "");

check_bin_file("${test}.bin", bytes());
check_bin_file("${test}_bank0.bin", bytes(0xC9,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xC9,0xC9));
check_bin_file("${test}_bank1.bin", bytes(0xCD,0x08,0x00,0x00,0x00,0x00,0x00,0x00,0xC9,0x00,0xC9));
check_bin_file("${test}_main.bin", bytes(0xCD,0x08,0x00,0x09,0x00,0xCD,0x08,0x00,0x0A,0x00,0xC9));


unlink_testfiles;
done_testing;
