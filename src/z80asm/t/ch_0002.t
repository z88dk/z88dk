#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test correction of CH_0002, see hist.c for description
z80asm_ok("", "", "", "ld a,    3",		bytes(0x3e, 0x03));
z80asm_ok("", "", "", "ld a,+ + 3",		bytes(0x3e, 0x03));
z80asm_ok("", "", "", "ld a,+ - 3",		bytes(0x3e, 0xfd));

z80asm_ok("", "", "", "ld a,-   3",		bytes(0x3e, 0xfd));
z80asm_ok("", "", "", "ld a,- + 3",		bytes(0x3e, 0xfd));
z80asm_ok("", "", "", "ld a,- - 3",		bytes(0x3e, 0x03));

z80asm_ok("", "", "", "inc (ix -  3)",	bytes(0xdd, 0x34, 0xfd));
z80asm_ok("", "", "", "inc (ix - -3)",	bytes(0xdd, 0x34, 0x03));
z80asm_ok("", "", "", "inc (ix - +3)",	bytes(0xdd, 0x34, 0xfd));

z80asm_ok("", "", "", "inc (ix + 3)", 	bytes(0xdd, 0x34, 0x03));
z80asm_ok("", "", "", "inc (ix + -3)",	bytes(0xdd, 0x34, 0xfd));
z80asm_ok("", "", "", "inc (ix + +3)",	bytes(0xdd, 0x34, 0x03));

unlink_testfiles;
done_testing;
