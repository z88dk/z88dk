#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2521
# z80asm Pseudo instructions causing trouble

spew("$test.asm", <<END);
	ld (0xff00),a
	ld a,(0xff00)
	ld (0xff00+0),a
	ld a,(0xff00+0)
	ld (0xff00+1),a
	ld a,(0xff00+1)
END

capture_ok("z88dk-z80asm -mgbz80 -l -b $test.asm", "");
check_bin_file("$test.bin", bytes(0xE0,  0, 0xF0,  0,
								  0xE0,  0, 0xF0,  0,
								  0xE0,  1, 0xF0,  1));

capture_ok("z88dk-z80asm -mz80 -l -b $test.asm", "");
check_bin_file("$test.bin", bytes(0x32,  0, 0xFF, 0x3A,  0, 0xFF,
								  0x32,  0, 0xFF, 0x3A,  0, 0xFF,
								  0x32,  1, 0xFF, 0x3A,  1, 0xFF));

spew("$test.asm", <<END);
	ld (0xff00+c),a
	ld a,(0xff00+c)
END

capture_ok("z88dk-z80asm -mgbz80 -l -b $test.asm", "");
check_bin_file("$test.bin", bytes(0xE2,
								  0xF2));


unlink_testfiles;
done_testing;
