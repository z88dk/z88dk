#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/1077
# z80asm: optimize for speed - replace JR by JP

z80asm_ok("-b", 			"", "", "djnz 0", 	bytes(0x10, 0xFE));
z80asm_ok("-b -opt-speed", 	"", "", "djnz 0", 	bytes(0x10, 0xFE));

z80asm_ok("-b", 			"", "", "jr 0", 	bytes(0x18, 0xFE));
z80asm_ok("-b -opt-speed", 	"", "", "jr 0", 	bytes(0xC3, 0x00, 0x00));

z80asm_ok("-b", 			"", "", "jp 0", 	bytes(0xC3, 0x00, 0x00));
z80asm_ok("-b -opt-speed", 	"", "", "jp 0", 	bytes(0xC3, 0x00, 0x00));

z80asm_ok("-b", 			"", "", "jr nz, 0",	bytes(0x20, 0xFE));
z80asm_ok("-b -opt-speed", 	"", "", "jr nz, 0",	bytes(0xC2, 0x00, 0x00));

z80asm_ok("-b", 			"", "", "jp nz, 0",	bytes(0xC2, 0x00, 0x00));
z80asm_ok("-b -opt-speed", 	"", "", "jp nz, 0",	bytes(0xC2, 0x00, 0x00));

z80asm_ok("-b", 			"", "", "jr z, 0",	bytes(0x28, 0xFE));
z80asm_ok("-b -opt-speed", 	"", "", "jr z, 0",	bytes(0xCA, 0x00, 0x00));

z80asm_ok("-b", 			"", "", "jp z, 0",	bytes(0xCA, 0x00, 0x00));
z80asm_ok("-b -opt-speed", 	"", "", "jp z, 0",	bytes(0xCA, 0x00, 0x00));

z80asm_ok("-b", 			"", "", "jr nc, 0",	bytes(0x30, 0xFE));
z80asm_ok("-b -opt-speed", 	"", "", "jr nc, 0",	bytes(0xD2, 0x00, 0x00));

z80asm_ok("-b", 			"", "", "jp nc, 0",	bytes(0xD2, 0x00, 0x00));
z80asm_ok("-b -opt-speed", 	"", "", "jp nc, 0",	bytes(0xD2, 0x00, 0x00));

z80asm_ok("-b", 			"", "", "jr c, 0",	bytes(0x38, 0xFE));
z80asm_ok("-b -opt-speed", 	"", "", "jr c, 0",	bytes(0xDA, 0x00, 0x00));

z80asm_ok("-b", 			"", "", "jp c, 0",	bytes(0xDA, 0x00, 0x00));
z80asm_ok("-b -opt-speed", 	"", "", "jp c, 0",	bytes(0xDA, 0x00, 0x00));


unlink_testfiles;
done_testing;
