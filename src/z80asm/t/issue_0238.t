#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# https://github.com/z88dk/z88dk/issues/238
# A parenthesis inside (ix+...) is part of the displacement.

z80asm_ok( "", "", "",
    "ld a,(ix+3)"            => bytes( 0xDD, 0x7E, 0x03 ),
    "ld a,(ix+1+2)"          => bytes( 0xDD, 0x7E, 0x03 ),
    "ld a,(ix+(3))"          => bytes( 0xDD, 0x7E, 0x03 ),
    "ld a,(ix+(1+2))"        => bytes( 0xDD, 0x7E, 0x03 ),
    "ld a,(ix+((3)))"        => bytes( 0xDD, 0x7E, 0x03 ),
    "ld a,(ix+(-1))"         => bytes( 0xDD, 0x7E, 0xFF ),
    "ld a,(ix-(1))"          => bytes( 0xDD, 0x7E, 0xFF ),
    "ld a,(ix+(1)+2)"        => bytes( 0xDD, 0x7E, 0x03 ),
    "ld a,(ix+1+(2))"        => bytes( 0xDD, 0x7E, 0x03 ),
    "ld a,(ix+(1)+(2))"      => bytes( 0xDD, 0x7E, 0x03 ),
    "ld a,(iy+(3))"          => bytes( 0xFD, 0x7E, 0x03 ),
    "ld (ix+(3)),a"          => bytes( 0xDD, 0x77, 0x03 ),
    "ld a,(ix)"              => bytes( 0xDD, 0x7E, 0x00 ),
    "ld hl,(1+2)"            => bytes( 0x2A, 0x03, 0x00 ),
    "ld hl,((1+2))"          => bytes( 0x2A, 0x03, 0x00 ),
    "ld hl,((1)+(2))"        => bytes( 0x2A, 0x03, 0x00 ),
    "defb (1+2), ((3))"      => bytes( 0x03, 0x03 ),
    "defb [1+2]"             => bytes( 0x03 ),
    "ld a,(ix+[3])"          => bytes( 0xDD, 0x7E, 0x03 ),
    "bit 0,(ix+(2+1))"       => bytes( 0xDD, 0xCB, 0x03, 0x46 ),
    "add a,(ix+(1+2))"       => bytes( 0xDD, 0x86, 0x03 ),
    "ld a,(ix+(1<<2))"       => bytes( 0xDD, 0x7E, 0x04 ),
    "ld a,(ix+((1+2)*2))"    => bytes( 0xDD, 0x7E, 0x06 ),
    "base: equ 2"            => "",
    "ld a,(ix+(base+1))"     => bytes( 0xDD, 0x7E, 0x03 ),
);

z80asm_nok( "", "", "ld a,(ix+(3)", <<END );
$test.asm:1: error: syntax error
  ^---- ld a,(ix+(3)
END

z80asm_nok( "", "", "ld a,(ix+())", <<END );
$test.asm:1: error: syntax error
  ^---- ld a,(ix+())
END

unlink_testfiles;
done_testing;
