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

#------------------------------------------------------------------------------
# DMA.WR0
#------------------------------------------------------------------------------

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr0
	ld a,2
ASM
Error at file 'test.asm' line 2: syntax error
1 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	extern ext
	ld a,1
	dma.wr0 ext
	ld a,2
ASM
Error at file 'test.asm' line 3: expected constant expression
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
	dma.wr0 255
	ld a,2
ASM
Error at file 'test.asm' line 2: base register byte '255' is illegal
1 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr0 0
	dma.wr0 2
	dma.wr0 3
	dma.wr0 128
	ld a,2
ASM
Error at file 'test.asm' line 2: base register byte '0' is illegal
Error at file 'test.asm' line 3: base register byte '2' is illegal
Error at file 'test.asm' line 4: base register byte '3' is illegal
Error at file 'test.asm' line 5: base register byte '128' is illegal
4 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr0 0
	ld a,2
ASM
Error at file 'test.asm' line 2: base register byte '0' is illegal
1 errors occurred during assembly
ERR

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

#------------------------------------------------------------------------------
# DMA.WR1
#------------------------------------------------------------------------------

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr1 1
	dma.wr1 2
	dma.wr1 3
	dma.wr1 5
	dma.wr1 6
	dma.wr1 7
	dma.wr1 128
	ld a,2
ASM
Error at file 'test.asm' line 2: base register byte '1' is illegal
Error at file 'test.asm' line 3: base register byte '2' is illegal
Error at file 'test.asm' line 4: base register byte '3' is illegal
Error at file 'test.asm' line 5: base register byte '5' is illegal
Error at file 'test.asm' line 6: base register byte '6' is illegal
Error at file 'test.asm' line 7: base register byte '7' is illegal
Error at file 'test.asm' line 8: base register byte '128' is illegal
7 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 0, "", "");
	ld a,1
	dma.wr1 0x04
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x04, 
				0x3E, 2));

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr1 0x44
	ld a,2
ASM
Error at file 'test.asm' line 2: missing arguments
1 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	extern ext
	ld a,1
	dma.wr1 0x44, ext
	ld a,2
ASM
Error at file 'test.asm' line 3: expected constant expression
1 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr1 0x44, 0x10
	dma.wr1 0x44, 0x20
	dma.wr1 0x44, 0x30
	dma.wr1 0x44, 0x03
	ld a,2
ASM
Error at file 'test.asm' line 2: port A timing is illegal
Error at file 'test.asm' line 3: port A timing is illegal
Error at file 'test.asm' line 4: port A timing is illegal
Error at file 'test.asm' line 5: port A timing is illegal
4 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 0, "", "");
	ld a,1
	dma.wr1 0x44, 0x00
	dma.wr1 0x44, 0x01
	dma.wr1 0x44, 0x02
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x44, 0x00,
				0x44, 0x01,
				0x44, 0x02,
				0x3E, 2));


z80asm(<<'ASM', "-b", 0, "", <<'WARN');
	ld a,1
	dma.wr1 0x44, 0x80
	dma.wr1 0x44, 0x40
	dma.wr1 0x44, 0x08
	dma.wr1 0x44, 0x04
	ld a,2
ASM
Warning at file 'test.asm' line 2: DMA does not support half cycle timing
Warning at file 'test.asm' line 3: DMA does not support half cycle timing
Warning at file 'test.asm' line 4: DMA does not support half cycle timing
Warning at file 'test.asm' line 5: DMA does not support half cycle timing
WARN
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x44, 0x80,
				0x44, 0x40,
				0x44, 0x08,
				0x44, 0x04,
				0x3E, 2));

#------------------------------------------------------------------------------
# DMA.WR2
#------------------------------------------------------------------------------

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr2 1
	dma.wr2 2
	dma.wr2 3
	dma.wr2 4
	dma.wr2 5
	dma.wr2 6
	dma.wr2 7
	dma.wr2 128
	ld a,2
ASM
Error at file 'test.asm' line 2: base register byte '1' is illegal
Error at file 'test.asm' line 3: base register byte '2' is illegal
Error at file 'test.asm' line 4: base register byte '3' is illegal
Error at file 'test.asm' line 5: base register byte '4' is illegal
Error at file 'test.asm' line 6: base register byte '5' is illegal
Error at file 'test.asm' line 7: base register byte '6' is illegal
Error at file 'test.asm' line 8: base register byte '7' is illegal
Error at file 'test.asm' line 9: base register byte '128' is illegal
8 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 0, "", "");
	ld a,1
	dma.wr2 0x00
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x00, 
				0x3E, 2));

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr2 0x40
	ld a,2
ASM
Error at file 'test.asm' line 2: missing arguments
1 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	extern ext
	ld a,1
	dma.wr2 0x40, ext
	ld a,2
ASM
Error at file 'test.asm' line 3: expected constant expression
1 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr2 0x40, 0x10
	dma.wr2 0x40, 0x03
	ld a,2
ASM
Error at file 'test.asm' line 2: port B timing is illegal
Error at file 'test.asm' line 3: port B timing is illegal
2 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 0, "", "");
	ld a,1
	dma.wr2 0x40, 0x00
	dma.wr2 0x40, 0x01
	dma.wr2 0x40, 0x02
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x40, 0x00,
				0x40, 0x01,
				0x40, 0x02,
				0x3E, 2));

z80asm(<<'ASM', "-b", 0, "", <<'WARN');
	ld a,1
	dma.wr2 0x40, 0x80
	dma.wr2 0x40, 0x40
	dma.wr2 0x40, 0x08
	dma.wr2 0x40, 0x04
	ld a,2
ASM
Warning at file 'test.asm' line 2: DMA does not support half cycle timing
Warning at file 'test.asm' line 3: DMA does not support half cycle timing
Warning at file 'test.asm' line 4: DMA does not support half cycle timing
Warning at file 'test.asm' line 5: DMA does not support half cycle timing
WARN
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x40, 0x80,
				0x40, 0x40,
				0x40, 0x08,
				0x40, 0x04,
				0x3E, 2));

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr2 0x40, 0x20
	ld a,2
ASM
Error at file 'test.asm' line 2: missing arguments
1 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 0, "", "");
	ld a,1
lbl:dma.wr2 0x40, 0x20, lbl
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x40, 0x20, 2,
				0x3E, 2));

#------------------------------------------------------------------------------
# DMA.WR3
#------------------------------------------------------------------------------

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr3 1
	dma.wr2 2
	dma.wr2 3
	ld a,2
ASM
Error at file 'test.asm' line 2: base register byte '1' is illegal
Error at file 'test.asm' line 3: base register byte '2' is illegal
Error at file 'test.asm' line 4: base register byte '3' is illegal
3 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 0, "", "");
	ld a,1
	dma.wr3 0x00
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x80, 
				0x3E, 2));


z80asm(<<'ASM', "-b", 0, "", <<'WARN');
	ld a,1
	dma.wr3 0b00000100
	dma.wr3 0b00100000
	dma.wr3 0b01000000
	ld a,2
ASM
Warning at file 'test.asm' line 2: DMA does not support some features
Warning at file 'test.asm' line 3: DMA does not support some features
Warning at file 'test.asm' line 4: DMA does not support some features
WARN
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x84, 
				0xA0, 
				0xC0, 
				0x3E, 2));

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr3 0x88
	ld a,2
ASM
Error at file 'test.asm' line 2: missing arguments
1 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 0, "", "");
	extern ext
	ld a,1
	dma.wr3 0x88, 23
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x88, 23,
				0x3E, 2));

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr3 0x98, 23
	ld a,2
ASM
Error at file 'test.asm' line 2: missing arguments
1 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 0, "", "");
	extern ext
	ld a,1
	dma.wr3 0x98, 23, 45
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x98, 23, 45,
				0x3E, 2));


#------------------------------------------------------------------------------
# DMA.WR4
#------------------------------------------------------------------------------

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr4 2
	ld a,2
ASM
Error at file 'test.asm' line 2: base register byte '2' is illegal
1 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr4 0x11
	ld a,2
ASM
Error at file 'test.asm' line 2: DMA does not support interrupts
1 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr4 0x01
	dma.wr4 0x61
	ld a,2
ASM
Error at file 'test.asm' line 2: DMA mode is illegal
Error at file 'test.asm' line 3: DMA mode is illegal
2 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 0, "", "");
	ld a,1
	dma.wr4 0x40
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0xC1, 
				0x3E, 2));

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr4 0x44
	ld a,2
ASM
Error at file 'test.asm' line 2: missing arguments
1 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr4 0x48
	ld a,2
ASM
Error at file 'test.asm' line 2: missing arguments
1 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 0, "", "");
	ld a,1
	dma.wr4 0x44, 23
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0xC5, 23,
				0x3E, 2));

z80asm(<<'ASM', "-b", 0, "", "");
	ld a,1
	dma.wr4 0x48, 23
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0xC9, 23,
				0x3E, 2));

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr4 0x4C
	ld a,2
ASM
Error at file 'test.asm' line 2: missing arguments
1 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 0, "", "");
	ld a,1
	dma.wr4 0x4C, 0x1234
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0xCD, 0x34, 0x12,
				0x3E, 2));


#------------------------------------------------------------------------------
# DMA.WR5
#------------------------------------------------------------------------------

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr5 0x01
	dma.wr5 0x04
	dma.wr5 0x40
	ld a,2
ASM
Error at file 'test.asm' line 2: base register byte '1' is illegal
Error at file 'test.asm' line 3: base register byte '4' is illegal
Error at file 'test.asm' line 4: base register byte '64' is illegal
3 errors occurred during assembly
ERR

z80asm(<<'ASM', "-b", 0, "", <<'WARN');
	ld a,1
	dma.wr5 0
	dma.wr5 0x08
	ld a,2
ASM
Warning at file 'test.asm' line 3: DMA does not support ready signals
WARN
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x82, 
				0x8A,
				0x3E, 2));




unlink_testfiles();
done_testing();
