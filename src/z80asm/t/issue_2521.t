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
	ld (0xff00-1),a
	ld a,(0xff00-1)
END

capture_ok("z88dk-z80asm -mgbz80 -l -b $test.asm", "");
check_bin_file("$test.bin", bytes(0xEA, 0, 0xFF, 0xFA, 0, 0xFF,
								  0xE0, 0, 0xF0, 0,
								  0xE0, 1, 0xF0, 1,
								  0xE0, 0xFF, 0xF0, 0xFF));

spew("$test.asm", <<END);
	ld (0xff00),a
	ld a,(0xff00)
END

capture_ok("z88dk-z80asm -mz80 -l -b $test.asm", "");
check_bin_file("$test.bin", bytes(0x32, 0,0xFF, 0x3A, 0,0xFF));

spew("$test.asm", <<END);
	ld (0xff00+0),a
	ld a,(0xff00+0)
	ld (0xff00+1),a
	ld a,(0xff00+1)
	ld (0xff00-1),a
	ld a,(0xff00-1)
END

capture_nok("z88dk-z80asm -mz80 -l -b $test.asm", <<END);
$test.asm:1: error: illegal identifier
  ^---- ld (0xff00+0),a
      ^---- ldh(0),a
$test.asm:2: error: illegal identifier
  ^---- ld a,(0xff00+0)
      ^---- ldh a,(0)
$test.asm:3: error: illegal identifier
  ^---- ld (0xff00+1),a
      ^---- ldh(1),a
$test.asm:4: error: illegal identifier
  ^---- ld a,(0xff00+1)
      ^---- ldh a,(1)
$test.asm:5: error: illegal identifier
  ^---- ld (0xff00-1),a
      ^---- ldh(-1),a
$test.asm:6: error: illegal identifier
  ^---- ld a,(0xff00-1)
      ^---- ldh a,(-1)
END

unlink_testfiles;
done_testing;
