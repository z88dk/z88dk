#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

spew("${test}.asm", <<'END');
foo:
	nop
@loop1:
	jp @loop1
@loop2:
	call bar
	jp @loop2

bar:
	ret
END

capture_ok("z88dk-z80asm -b ${test}.asm", "");
check_bin_file("${test}.bin", bytes(0x00,
									0xc3, 0x01, 0x00,
									0xcd, 0x0a, 0x00,
									0xc3, 0x04, 0x00,
									0xc9));

spew("${test}.asm", <<'END');
FOOBAR = 1

foo:
@loop:
	ld a,(hl)
	cp FOOBAR
	inc hl
	jr nz,@loop
END

capture_ok("z88dk-z80asm -b ${test}.asm", "");
check_bin_file("${test}.bin", bytes(0x7e,
									0xfe, 0x01,
									0x23,
									0x20, -6));

unlink_testfiles;
done_testing;
