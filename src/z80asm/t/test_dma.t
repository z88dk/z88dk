#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2018
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/312
# z80asm: implement z80-zxn dma commands

use strict;
use warnings;
use v5.10;
use Test::More;
require './t/testlib.pl';

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr0
	ld a,2
ASM
Error at file 'test.asm' line 2: syntax error
1 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr0 -1
	ld a,2
ASM
Error at file 'test.asm' line 2: integer '-1' out of range
1 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr0 128
	ld a,2
ASM
Error at file 'test.asm' line 2: integer '128' out of range
1 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr0 3
	ld a,2
ASM
Error at file 'test.asm' line 2: base register byte '3' is illegal
1 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 0, "", "");
	ld a,1
	dma.wr0 0
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 0x3E, 1, 0x01, 0x3E, 2));

z80asm(<<'ASM', "-b", 0, "", "");
	ld a,1
	dma.wr0 1
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 0x3E, 1, 0x01, 0x3E, 2));

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr0 1, 99
	ld a,2
ASM
Error at file 'test.asm' line 2: extra arguments
1 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr0 1, 
			99
	ld a,2
ASM
Error at file 'test.asm' line 3: extra arguments
1 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr0 1, 
ASM
Error at file 'test.asm' line 3: syntax error
1 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
lbl:dma.wr0 0x09
	ld a,2
ASM
Error at file 'test.asm' line 2: missing arguments
1 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 0, "", "");
	ld a,1
lbl:dma.wr0 0x08, 
			lbl
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x09, 0x02, 
				0x3E, 2));

z80asm(<<'ASM', "-b", 0, "", "");
	ld a,1
lbl:dma.wr0 0x09, 
			lbl
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x09, 0x02, 
				0x3E, 2));

z80asm(<<'ASM', "-b", 0, "", "");
	ld a,1
lbl:dma.wr0 0x11, 
			lbl
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x11, 0x02, 
				0x3E, 2));

z80asm(<<'ASM', "-b", 0, "", "");
	ld a,1
lbl:dma.wr0 0x19, 
			lbl+0x8000
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x19, 0x02, 0x80,
				0x3E, 2));

z80asm(<<'ASM', "-b", 0, "", "");
	ld a,1
lbl:dma.wr0 0x21, 
			lbl
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x21, 0x02,
				0x3E, 2));

z80asm(<<'ASM', "-b", 0, "", "");
	ld a,1
lbl:dma.wr0 0x41, 
			lbl
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x41, 0x02,
				0x3E, 2));

z80asm(<<'ASM', "-b", 0, "", "");
	ld a,1
lbl:dma.wr0 0x61, 
			lbl+0x8000
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x61, 0x02, 0x80,
				0x3E, 2));

z80asm(<<'ASM', "-b", 0, "", "");
	ld a,1
lbl:dma.wr0 0x79, 
			lbl+0x4000,
			lbl+0x8000
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x79, 0x02, 0x40, 0x02, 0x80,
				0x3E, 2));


unlink_testfiles();
done_testing();
