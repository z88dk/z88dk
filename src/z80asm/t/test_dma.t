#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2018
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/312
# z80asm: implement z80n dma commands

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

#------------------------------------------------------------------------------
# Check CPU
#------------------------------------------------------------------------------

z80asm(<<'ASM', "-b", 1, "", <<'ERR');
	ld a,1
	dma.wr0 1
	ld a,2
ASM
Error at file 'test.asm' line 2: illegal identifier
ERR

z80asm(<<'ASM', "-b -mz80n", 0, "", "");
	ld a,1
	dma.wr0 1
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 0x3E, 1, 0x01, 0x3E, 2));

#------------------------------------------------------------------------------
# DMA.WR0
#------------------------------------------------------------------------------

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	ld a,1
	dma.wr0
	ld a,2
ASM
Error at file 'test.asm' line 2: syntax error
ERR

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	extern ext
	ld a,1
	dma.wr0 ext
	ld a,2
ASM
Error at file 'test.asm' line 3: expected constant expression
ERR

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	ld a,1
	dma.wr0 -1
	ld a,2
ASM
Error at file 'test.asm' line 2: integer '-1' out of range
ERR

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	ld a,1
	dma.wr0 255
	ld a,2
ASM
Error at file 'test.asm' line 2: base register byte '255' is illegal
ERR

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
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
ERR

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	ld a,1
	dma.wr0 0
	ld a,2
ASM
Error at file 'test.asm' line 2: base register byte '0' is illegal
ERR

z80asm(<<'ASM', "-b -mz80n", 0, "", "");
	ld a,1
	dma.wr0 1
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 0x3E, 1, 0x01, 0x3E, 2));

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	ld a,1
	dma.wr0 1, 99
	ld a,2
ASM
Error at file 'test.asm' line 2: DMA too many arguments
ERR

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	ld a,1
	dma.wr0 1, 
			99
	ld a,2
ASM
Error at file 'test.asm' line 3: DMA too many arguments
ERR

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	ld a,1
	dma.wr0 1, 
ASM
Error at file 'test.asm' line 3: syntax error
ERR

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	ld a,1
lbl:dma.wr0 0x09
	ld a,2
ASM
Error at file 'test.asm' line 2: DMA missing register group member(s)
ERR

z80asm(<<'ASM', "-b -mz80n", 0, "", "");
	ld a,1
lbl:dma.wr0 0x09, 
			lbl
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x09, 0x02, 
				0x3E, 2));

z80asm(<<'ASM', "-b -mz80n", 0, "", "");
	ld a,1
lbl:dma.wr0 0x11, 
			lbl
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x11, 0x02, 
				0x3E, 2));

z80asm(<<'ASM', "-b -mz80n", 0, "", "");
	ld a,1
lbl:dma.wr0 0x19, 
			lbl+0x8000
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x19, 0x02, 0x80,
				0x3E, 2));

z80asm(<<'ASM', "-b -mz80n", 0, "", "");
	ld a,1
lbl:dma.wr0 0x21, 
			lbl
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x21, 0x02,
				0x3E, 2));

z80asm(<<'ASM', "-b -mz80n", 0, "", "");
	ld a,1
lbl:dma.wr0 0x41, 
			lbl
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x41, 0x02,
				0x3E, 2));

z80asm(<<'ASM', "-b -mz80n", 0, "", "");
	ld a,1
lbl:dma.wr0 0x61, 
			lbl+0x8000
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x61, 0x02, 0x80,
				0x3E, 2));

z80asm(<<'ASM', "-b -mz80n", 0, "", "");
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

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
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
ERR

z80asm(<<'ASM', "-b -mz80n", 0, "", "");
	ld a,1
	dma.wr1 0x04
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x04, 
				0x3E, 2));

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	ld a,1
	dma.wr1 0x44
	ld a,2
ASM
Error at file 'test.asm' line 2: DMA missing register group member(s)
ERR

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	extern ext
	ld a,1
	dma.wr1 0x44, ext
	ld a,2
ASM
Error at file 'test.asm' line 3: expected constant expression
ERR

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
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
ERR

z80asm(<<'ASM', "-b -mz80n", 0, "", "");
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


z80asm(<<'ASM', "-b -mz80n", 0, "", <<'WARN');
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

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
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
ERR

z80asm(<<'ASM', "-b -mz80n", 0, "", "");
	ld a,1
	dma.wr2 0x00
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x00, 
				0x3E, 2));

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	ld a,1
	dma.wr2 0x40
	ld a,2
ASM
Error at file 'test.asm' line 2: DMA missing register group member(s)
ERR

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	extern ext
	ld a,1
	dma.wr2 0x40, ext
	ld a,2
ASM
Error at file 'test.asm' line 3: expected constant expression
ERR

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	ld a,1
	dma.wr2 0x40, 0x10
	dma.wr2 0x40, 0x03
	ld a,2
ASM
Error at file 'test.asm' line 2: port B timing is illegal
Error at file 'test.asm' line 3: port B timing is illegal
ERR

z80asm(<<'ASM', "-b -mz80n", 0, "", "");
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

z80asm(<<'ASM', "-b -mz80n", 0, "", <<'WARN');
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

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	ld a,1
	dma.wr2 0x40, 0x20
	ld a,2
ASM
Error at file 'test.asm' line 2: DMA missing register group member(s)
ERR

z80asm(<<'ASM', "-b -mz80n", 0, "", "");
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

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	ld a,1
	dma.wr3 1
	dma.wr2 2
	dma.wr2 3
	ld a,2
ASM
Error at file 'test.asm' line 2: base register byte '1' is illegal
Error at file 'test.asm' line 3: base register byte '2' is illegal
Error at file 'test.asm' line 4: base register byte '3' is illegal
ERR

z80asm(<<'ASM', "-b -mz80n", 0, "", "");
	ld a,1
	dma.wr3 0x00
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x80, 
				0x3E, 2));


z80asm(<<'ASM', "-b -mz80n", 0, "", <<'WARN');
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

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	ld a,1
	dma.wr3 0x88
	ld a,2
ASM
Error at file 'test.asm' line 2: DMA missing register group member(s)
ERR

z80asm(<<'ASM', "-b -mz80n", 0, "", "");
	extern ext
	ld a,1
	dma.wr3 0x88, 23
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x88, 23,
				0x3E, 2));

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	ld a,1
	dma.wr3 0x98, 23
	ld a,2
ASM
Error at file 'test.asm' line 2: DMA missing register group member(s)
ERR

z80asm(<<'ASM', "-b -mz80n", 0, "", "");
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

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	ld a,1
	dma.wr4 2
	ld a,2
ASM
Error at file 'test.asm' line 2: base register byte '2' is illegal
ERR

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	ld a,1
	dma.wr4 0x11
	ld a,2
ASM
Error at file 'test.asm' line 2: DMA does not support interrupts
ERR

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	ld a,1
	dma.wr4 0x01
	dma.wr4 0x61
	ld a,2
ASM
Error at file 'test.asm' line 2: DMA mode is illegal
Error at file 'test.asm' line 3: DMA mode is illegal
ERR

z80asm(<<'ASM', "-b -mz80n", 0, "", "");
	ld a,1
	dma.wr4 0x40
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0xC1, 
				0x3E, 2));

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	ld a,1
	dma.wr4 0x44
	ld a,2
ASM
Error at file 'test.asm' line 2: DMA missing register group member(s)
ERR

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	ld a,1
	dma.wr4 0x48
	ld a,2
ASM
Error at file 'test.asm' line 2: DMA missing register group member(s)
ERR

z80asm(<<'ASM', "-b -mz80n", 0, "", "");
	ld a,1
	dma.wr4 0x44, 23
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0xC5, 23,
				0x3E, 2));

z80asm(<<'ASM', "-b -mz80n", 0, "", "");
	ld a,1
	dma.wr4 0x48, 23
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0xC9, 23,
				0x3E, 2));

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	ld a,1
	dma.wr4 0x4C
	ld a,2
ASM
Error at file 'test.asm' line 2: DMA missing register group member(s)
ERR

z80asm(<<'ASM', "-b -mz80n", 0, "", "");
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

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	ld a,1
	dma.wr5 0x01
	dma.wr5 0x04
	dma.wr5 0x40
	ld a,2
ASM
Error at file 'test.asm' line 2: base register byte '1' is illegal
Error at file 'test.asm' line 3: base register byte '4' is illegal
Error at file 'test.asm' line 4: base register byte '64' is illegal
ERR

z80asm(<<'ASM', "-b -mz80n", 0, "", <<'WARN');
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

#------------------------------------------------------------------------------
# DMA.WR6 | DMA.CMD
#------------------------------------------------------------------------------

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	ld a,1
	dma.wr6 0x00
	dma.cmd 0x00
	dma.wr6 0x01
	dma.cmd 0x01
	dma.wr6 0x02
	dma.cmd 0x02
	dma.wr6 0x03
	dma.cmd 0x03
	dma.wr6 0x04
	dma.cmd 0x04
	dma.wr6 0x05
	dma.cmd 0x05
	dma.wr6 0x06
	dma.cmd 0x06
	dma.wr6 0x07
	dma.cmd 0x07
	dma.wr6 0x08
	dma.cmd 0x08
	dma.wr6 0x09
	dma.cmd 0x09
	dma.wr6 0x0A
	dma.cmd 0x0A
	dma.wr6 0x0B
	dma.cmd 0x0B
	dma.wr6 0x0C
	dma.cmd 0x0C
	dma.wr6 0x0D
	dma.cmd 0x0D
	dma.wr6 0x0E
	dma.cmd 0x0E
	dma.wr6 0x0F
	dma.cmd 0x0F
	dma.wr6 0x10
	dma.cmd 0x10
	dma.wr6 0x11
	dma.cmd 0x11
	dma.wr6 0x12
	dma.cmd 0x12
	dma.wr6 0x13
	dma.cmd 0x13
	dma.wr6 0x14
	dma.cmd 0x14
	dma.wr6 0x15
	dma.cmd 0x15
	dma.wr6 0x16
	dma.cmd 0x16
	dma.wr6 0x17
	dma.cmd 0x17
	dma.wr6 0x18
	dma.cmd 0x18
	dma.wr6 0x19
	dma.cmd 0x19
	dma.wr6 0x1A
	dma.cmd 0x1A
	dma.wr6 0x1B
	dma.cmd 0x1B
	dma.wr6 0x1C
	dma.cmd 0x1C
	dma.wr6 0x1D
	dma.cmd 0x1D
	dma.wr6 0x1E
	dma.cmd 0x1E
	dma.wr6 0x1F
	dma.cmd 0x1F
	dma.wr6 0x20
	dma.cmd 0x20
	dma.wr6 0x21
	dma.cmd 0x21
	dma.wr6 0x22
	dma.cmd 0x22
	dma.wr6 0x23
	dma.cmd 0x23
	dma.wr6 0x24
	dma.cmd 0x24
	dma.wr6 0x25
	dma.cmd 0x25
	dma.wr6 0x26
	dma.cmd 0x26
	dma.wr6 0x27
	dma.cmd 0x27
	dma.wr6 0x28
	dma.cmd 0x28
	dma.wr6 0x29
	dma.cmd 0x29
	dma.wr6 0x2A
	dma.cmd 0x2A
	dma.wr6 0x2B
	dma.cmd 0x2B
	dma.wr6 0x2C
	dma.cmd 0x2C
	dma.wr6 0x2D
	dma.cmd 0x2D
	dma.wr6 0x2E
	dma.cmd 0x2E
	dma.wr6 0x2F
	dma.cmd 0x2F
	dma.wr6 0x30
	dma.cmd 0x30
	dma.wr6 0x31
	dma.cmd 0x31
	dma.wr6 0x32
	dma.cmd 0x32
	dma.wr6 0x33
	dma.cmd 0x33
	dma.wr6 0x34
	dma.cmd 0x34
	dma.wr6 0x35
	dma.cmd 0x35
	dma.wr6 0x36
	dma.cmd 0x36
	dma.wr6 0x37
	dma.cmd 0x37
	dma.wr6 0x38
	dma.cmd 0x38
	dma.wr6 0x39
	dma.cmd 0x39
	dma.wr6 0x3A
	dma.cmd 0x3A
	dma.wr6 0x3B
	dma.cmd 0x3B
	dma.wr6 0x3C
	dma.cmd 0x3C
	dma.wr6 0x3D
	dma.cmd 0x3D
	dma.wr6 0x3E
	dma.cmd 0x3E
	dma.wr6 0x3F
	dma.cmd 0x3F
	dma.wr6 0x40
	dma.cmd 0x40
	dma.wr6 0x41
	dma.cmd 0x41
	dma.wr6 0x42
	dma.cmd 0x42
	dma.wr6 0x43
	dma.cmd 0x43
	dma.wr6 0x44
	dma.cmd 0x44
	dma.wr6 0x45
	dma.cmd 0x45
	dma.wr6 0x46
	dma.cmd 0x46
	dma.wr6 0x47
	dma.cmd 0x47
	dma.wr6 0x48
	dma.cmd 0x48
	dma.wr6 0x49
	dma.cmd 0x49
	dma.wr6 0x4A
	dma.cmd 0x4A
	dma.wr6 0x4B
	dma.cmd 0x4B
	dma.wr6 0x4C
	dma.cmd 0x4C
	dma.wr6 0x4D
	dma.cmd 0x4D
	dma.wr6 0x4E
	dma.cmd 0x4E
	dma.wr6 0x4F
	dma.cmd 0x4F
	dma.wr6 0x50
	dma.cmd 0x50
	dma.wr6 0x51
	dma.cmd 0x51
	dma.wr6 0x52
	dma.cmd 0x52
	dma.wr6 0x53
	dma.cmd 0x53
	dma.wr6 0x54
	dma.cmd 0x54
	dma.wr6 0x55
	dma.cmd 0x55
	dma.wr6 0x56
	dma.cmd 0x56
	dma.wr6 0x57
	dma.cmd 0x57
	dma.wr6 0x58
	dma.cmd 0x58
	dma.wr6 0x59
	dma.cmd 0x59
	dma.wr6 0x5A
	dma.cmd 0x5A
	dma.wr6 0x5B
	dma.cmd 0x5B
	dma.wr6 0x5C
	dma.cmd 0x5C
	dma.wr6 0x5D
	dma.cmd 0x5D
	dma.wr6 0x5E
	dma.cmd 0x5E
	dma.wr6 0x5F
	dma.cmd 0x5F
	dma.wr6 0x60
	dma.cmd 0x60
	dma.wr6 0x61
	dma.cmd 0x61
	dma.wr6 0x62
	dma.cmd 0x62
	dma.wr6 0x63
	dma.cmd 0x63
	dma.wr6 0x64
	dma.cmd 0x64
	dma.wr6 0x65
	dma.cmd 0x65
	dma.wr6 0x66
	dma.cmd 0x66
	dma.wr6 0x67
	dma.cmd 0x67
	dma.wr6 0x68
	dma.cmd 0x68
	dma.wr6 0x69
	dma.cmd 0x69
	dma.wr6 0x6A
	dma.cmd 0x6A
	dma.wr6 0x6B
	dma.cmd 0x6B
	dma.wr6 0x6C
	dma.cmd 0x6C
	dma.wr6 0x6D
	dma.cmd 0x6D
	dma.wr6 0x6E
	dma.cmd 0x6E
	dma.wr6 0x6F
	dma.cmd 0x6F
	dma.wr6 0x70
	dma.cmd 0x70
	dma.wr6 0x71
	dma.cmd 0x71
	dma.wr6 0x72
	dma.cmd 0x72
	dma.wr6 0x73
	dma.cmd 0x73
	dma.wr6 0x74
	dma.cmd 0x74
	dma.wr6 0x75
	dma.cmd 0x75
	dma.wr6 0x76
	dma.cmd 0x76
	dma.wr6 0x77
	dma.cmd 0x77
	dma.wr6 0x78
	dma.cmd 0x78
	dma.wr6 0x79
	dma.cmd 0x79
	dma.wr6 0x7A
	dma.cmd 0x7A
	dma.wr6 0x7B
	dma.cmd 0x7B
	dma.wr6 0x7C
	dma.cmd 0x7C
	dma.wr6 0x7D
	dma.cmd 0x7D
	dma.wr6 0x7E
	dma.cmd 0x7E
	dma.wr6 0x7F
	dma.cmd 0x7F
	dma.wr6 0x80
	dma.cmd 0x80
	dma.wr6 0x81
	dma.cmd 0x81
	dma.wr6 0x82
	dma.cmd 0x82
	dma.wr6 0x84
	dma.cmd 0x84
	dma.wr6 0x85
	dma.cmd 0x85
	dma.wr6 0x86
	dma.cmd 0x86
	dma.wr6 0x88
	dma.cmd 0x88
	dma.wr6 0x89
	dma.cmd 0x89
	dma.wr6 0x8A
	dma.cmd 0x8A
	dma.wr6 0x8C
	dma.cmd 0x8C
	dma.wr6 0x8D
	dma.cmd 0x8D
	dma.wr6 0x8E
	dma.cmd 0x8E
	dma.wr6 0x8F
	dma.cmd 0x8F
	dma.wr6 0x90
	dma.cmd 0x90
	dma.wr6 0x91
	dma.cmd 0x91
	dma.wr6 0x92
	dma.cmd 0x92
	dma.wr6 0x93
	dma.cmd 0x93
	dma.wr6 0x94
	dma.cmd 0x94
	dma.wr6 0x95
	dma.cmd 0x95
	dma.wr6 0x96
	dma.cmd 0x96
	dma.wr6 0x97
	dma.cmd 0x97
	dma.wr6 0x98
	dma.cmd 0x98
	dma.wr6 0x99
	dma.cmd 0x99
	dma.wr6 0x9A
	dma.cmd 0x9A
	dma.wr6 0x9B
	dma.cmd 0x9B
	dma.wr6 0x9C
	dma.cmd 0x9C
	dma.wr6 0x9D
	dma.cmd 0x9D
	dma.wr6 0x9E
	dma.cmd 0x9E
	dma.wr6 0x9F
	dma.cmd 0x9F
	dma.wr6 0xA0
	dma.cmd 0xA0
	dma.wr6 0xA1
	dma.cmd 0xA1
	dma.wr6 0xA2
	dma.cmd 0xA2
	dma.wr6 0xA4
	dma.cmd 0xA4
	dma.wr6 0xA5
	dma.cmd 0xA5
	dma.wr6 0xA6
	dma.cmd 0xA6
	dma.wr6 0xA8
	dma.cmd 0xA8
	dma.wr6 0xA9
	dma.cmd 0xA9
	dma.wr6 0xAA
	dma.cmd 0xAA
	dma.wr6 0xAC
	dma.cmd 0xAC
	dma.wr6 0xAD
	dma.cmd 0xAD
	dma.wr6 0xAE
	dma.cmd 0xAE
	dma.wr6 0xB0
	dma.cmd 0xB0
	dma.wr6 0xB1
	dma.cmd 0xB1
	dma.wr6 0xB2
	dma.cmd 0xB2
	dma.wr6 0xB4
	dma.cmd 0xB4
	dma.wr6 0xB5
	dma.cmd 0xB5
	dma.wr6 0xB6
	dma.cmd 0xB6
	dma.wr6 0xB8
	dma.cmd 0xB8
	dma.wr6 0xB9
	dma.cmd 0xB9
	dma.wr6 0xBA
	dma.cmd 0xBA
	dma.wr6 0xBC
	dma.cmd 0xBC
	dma.wr6 0xBD
	dma.cmd 0xBD
	dma.wr6 0xBE
	dma.cmd 0xBE
	dma.wr6 0xC0
	dma.cmd 0xC0
	dma.wr6 0xC1
	dma.cmd 0xC1
	dma.wr6 0xC2
	dma.cmd 0xC2
	dma.wr6 0xC4
	dma.cmd 0xC4
	dma.wr6 0xC5
	dma.cmd 0xC5
	dma.wr6 0xC6
	dma.cmd 0xC6
	dma.wr6 0xC8
	dma.cmd 0xC8
	dma.wr6 0xC9
	dma.cmd 0xC9
	dma.wr6 0xCA
	dma.cmd 0xCA
	dma.wr6 0xCC
	dma.cmd 0xCC
	dma.wr6 0xCD
	dma.cmd 0xCD
	dma.wr6 0xCE
	dma.cmd 0xCE
	dma.wr6 0xD0
	dma.cmd 0xD0
	dma.wr6 0xD1
	dma.cmd 0xD1
	dma.wr6 0xD2
	dma.cmd 0xD2
	dma.wr6 0xD4
	dma.cmd 0xD4
	dma.wr6 0xD5
	dma.cmd 0xD5
	dma.wr6 0xD6
	dma.cmd 0xD6
	dma.wr6 0xD7
	dma.cmd 0xD7
	dma.wr6 0xD8
	dma.cmd 0xD8
	dma.wr6 0xD9
	dma.cmd 0xD9
	dma.wr6 0xDA
	dma.cmd 0xDA
	dma.wr6 0xDB
	dma.cmd 0xDB
	dma.wr6 0xDC
	dma.cmd 0xDC
	dma.wr6 0xDD
	dma.cmd 0xDD
	dma.wr6 0xDE
	dma.cmd 0xDE
	dma.wr6 0xDF
	dma.cmd 0xDF
	dma.wr6 0xE0
	dma.cmd 0xE0
	dma.wr6 0xE1
	dma.cmd 0xE1
	dma.wr6 0xE2
	dma.cmd 0xE2
	dma.wr6 0xE3
	dma.cmd 0xE3
	dma.wr6 0xE4
	dma.cmd 0xE4
	dma.wr6 0xE5
	dma.cmd 0xE5
	dma.wr6 0xE6
	dma.cmd 0xE6
	dma.wr6 0xE7
	dma.cmd 0xE7
	dma.wr6 0xE8
	dma.cmd 0xE8
	dma.wr6 0xE9
	dma.cmd 0xE9
	dma.wr6 0xEA
	dma.cmd 0xEA
	dma.wr6 0xEB
	dma.cmd 0xEB
	dma.wr6 0xEC
	dma.cmd 0xEC
	dma.wr6 0xED
	dma.cmd 0xED
	dma.wr6 0xEE
	dma.cmd 0xEE
	dma.wr6 0xEF
	dma.cmd 0xEF
	dma.wr6 0xF0
	dma.cmd 0xF0
	dma.wr6 0xF1
	dma.cmd 0xF1
	dma.wr6 0xF2
	dma.cmd 0xF2
	dma.wr6 0xF3
	dma.cmd 0xF3
	dma.wr6 0xF4
	dma.cmd 0xF4
	dma.wr6 0xF5
	dma.cmd 0xF5
	dma.wr6 0xF6
	dma.cmd 0xF6
	dma.wr6 0xF7
	dma.cmd 0xF7
	dma.wr6 0xF8
	dma.cmd 0xF8
	dma.wr6 0xF9
	dma.cmd 0xF9
	dma.wr6 0xFA
	dma.cmd 0xFA
	dma.wr6 0xFB
	dma.cmd 0xFB
	dma.wr6 0xFC
	dma.cmd 0xFC
	dma.wr6 0xFD
	dma.cmd 0xFD
	dma.wr6 0xFE
	dma.cmd 0xFE
	dma.wr6 0xFF
	dma.cmd 0xFF
	ld a,2
ASM
Error at file 'test.asm' line 2: illegal DMA command
Error at file 'test.asm' line 3: illegal DMA command
Error at file 'test.asm' line 4: illegal DMA command
Error at file 'test.asm' line 5: illegal DMA command
Error at file 'test.asm' line 6: illegal DMA command
Error at file 'test.asm' line 7: illegal DMA command
Error at file 'test.asm' line 8: illegal DMA command
Error at file 'test.asm' line 9: illegal DMA command
Error at file 'test.asm' line 10: illegal DMA command
Error at file 'test.asm' line 11: illegal DMA command
Error at file 'test.asm' line 12: illegal DMA command
Error at file 'test.asm' line 13: illegal DMA command
Error at file 'test.asm' line 14: illegal DMA command
Error at file 'test.asm' line 15: illegal DMA command
Error at file 'test.asm' line 16: illegal DMA command
Error at file 'test.asm' line 17: illegal DMA command
Error at file 'test.asm' line 18: illegal DMA command
Error at file 'test.asm' line 19: illegal DMA command
Error at file 'test.asm' line 20: illegal DMA command
Error at file 'test.asm' line 21: illegal DMA command
Error at file 'test.asm' line 22: illegal DMA command
Error at file 'test.asm' line 23: illegal DMA command
Error at file 'test.asm' line 24: illegal DMA command
Error at file 'test.asm' line 25: illegal DMA command
Error at file 'test.asm' line 26: illegal DMA command
Error at file 'test.asm' line 27: illegal DMA command
Error at file 'test.asm' line 28: illegal DMA command
Error at file 'test.asm' line 29: illegal DMA command
Error at file 'test.asm' line 30: illegal DMA command
Error at file 'test.asm' line 31: illegal DMA command
Error at file 'test.asm' line 32: illegal DMA command
Error at file 'test.asm' line 33: illegal DMA command
Error at file 'test.asm' line 34: illegal DMA command
Error at file 'test.asm' line 35: illegal DMA command
Error at file 'test.asm' line 36: illegal DMA command
Error at file 'test.asm' line 37: illegal DMA command
Error at file 'test.asm' line 38: illegal DMA command
Error at file 'test.asm' line 39: illegal DMA command
Error at file 'test.asm' line 40: illegal DMA command
Error at file 'test.asm' line 41: illegal DMA command
Error at file 'test.asm' line 42: illegal DMA command
Error at file 'test.asm' line 43: illegal DMA command
Error at file 'test.asm' line 44: illegal DMA command
Error at file 'test.asm' line 45: illegal DMA command
Error at file 'test.asm' line 46: illegal DMA command
Error at file 'test.asm' line 47: illegal DMA command
Error at file 'test.asm' line 48: illegal DMA command
Error at file 'test.asm' line 49: illegal DMA command
Error at file 'test.asm' line 50: illegal DMA command
Error at file 'test.asm' line 51: illegal DMA command
Error at file 'test.asm' line 52: illegal DMA command
Error at file 'test.asm' line 53: illegal DMA command
Error at file 'test.asm' line 54: illegal DMA command
Error at file 'test.asm' line 55: illegal DMA command
Error at file 'test.asm' line 56: illegal DMA command
Error at file 'test.asm' line 57: illegal DMA command
Error at file 'test.asm' line 58: illegal DMA command
Error at file 'test.asm' line 59: illegal DMA command
Error at file 'test.asm' line 60: illegal DMA command
Error at file 'test.asm' line 61: illegal DMA command
Error at file 'test.asm' line 62: illegal DMA command
Error at file 'test.asm' line 63: illegal DMA command
Error at file 'test.asm' line 64: illegal DMA command
Error at file 'test.asm' line 65: illegal DMA command
Error at file 'test.asm' line 66: illegal DMA command
Error at file 'test.asm' line 67: illegal DMA command
Error at file 'test.asm' line 68: illegal DMA command
Error at file 'test.asm' line 69: illegal DMA command
Error at file 'test.asm' line 70: illegal DMA command
Error at file 'test.asm' line 71: illegal DMA command
Error at file 'test.asm' line 72: illegal DMA command
Error at file 'test.asm' line 73: illegal DMA command
Error at file 'test.asm' line 74: illegal DMA command
Error at file 'test.asm' line 75: illegal DMA command
Error at file 'test.asm' line 76: illegal DMA command
Error at file 'test.asm' line 77: illegal DMA command
Error at file 'test.asm' line 78: illegal DMA command
Error at file 'test.asm' line 79: illegal DMA command
Error at file 'test.asm' line 80: illegal DMA command
Error at file 'test.asm' line 81: illegal DMA command
Error at file 'test.asm' line 82: illegal DMA command
Error at file 'test.asm' line 83: illegal DMA command
Error at file 'test.asm' line 84: illegal DMA command
Error at file 'test.asm' line 85: illegal DMA command
Error at file 'test.asm' line 86: illegal DMA command
Error at file 'test.asm' line 87: illegal DMA command
Error at file 'test.asm' line 88: illegal DMA command
Error at file 'test.asm' line 89: illegal DMA command
Error at file 'test.asm' line 90: illegal DMA command
Error at file 'test.asm' line 91: illegal DMA command
Error at file 'test.asm' line 92: illegal DMA command
Error at file 'test.asm' line 93: illegal DMA command
Error at file 'test.asm' line 94: illegal DMA command
Error at file 'test.asm' line 95: illegal DMA command
Error at file 'test.asm' line 96: illegal DMA command
Error at file 'test.asm' line 97: illegal DMA command
Error at file 'test.asm' line 98: illegal DMA command
Error at file 'test.asm' line 99: illegal DMA command
Error at file 'test.asm' line 100: illegal DMA command
Error at file 'test.asm' line 101: illegal DMA command
Error at file 'test.asm' line 102: illegal DMA command
Error at file 'test.asm' line 103: illegal DMA command
Error at file 'test.asm' line 104: illegal DMA command
Error at file 'test.asm' line 105: illegal DMA command
Error at file 'test.asm' line 106: illegal DMA command
Error at file 'test.asm' line 107: illegal DMA command
Error at file 'test.asm' line 108: illegal DMA command
Error at file 'test.asm' line 109: illegal DMA command
Error at file 'test.asm' line 110: illegal DMA command
Error at file 'test.asm' line 111: illegal DMA command
Error at file 'test.asm' line 112: illegal DMA command
Error at file 'test.asm' line 113: illegal DMA command
Error at file 'test.asm' line 114: illegal DMA command
Error at file 'test.asm' line 115: illegal DMA command
Error at file 'test.asm' line 116: illegal DMA command
Error at file 'test.asm' line 117: illegal DMA command
Error at file 'test.asm' line 118: illegal DMA command
Error at file 'test.asm' line 119: illegal DMA command
Error at file 'test.asm' line 120: illegal DMA command
Error at file 'test.asm' line 121: illegal DMA command
Error at file 'test.asm' line 122: illegal DMA command
Error at file 'test.asm' line 123: illegal DMA command
Error at file 'test.asm' line 124: illegal DMA command
Error at file 'test.asm' line 125: illegal DMA command
Error at file 'test.asm' line 126: illegal DMA command
Error at file 'test.asm' line 127: illegal DMA command
Error at file 'test.asm' line 128: illegal DMA command
Error at file 'test.asm' line 129: illegal DMA command
Error at file 'test.asm' line 130: illegal DMA command
Error at file 'test.asm' line 131: illegal DMA command
Error at file 'test.asm' line 132: illegal DMA command
Error at file 'test.asm' line 133: illegal DMA command
Error at file 'test.asm' line 134: illegal DMA command
Error at file 'test.asm' line 135: illegal DMA command
Error at file 'test.asm' line 136: illegal DMA command
Error at file 'test.asm' line 137: illegal DMA command
Error at file 'test.asm' line 138: illegal DMA command
Error at file 'test.asm' line 139: illegal DMA command
Error at file 'test.asm' line 140: illegal DMA command
Error at file 'test.asm' line 141: illegal DMA command
Error at file 'test.asm' line 142: illegal DMA command
Error at file 'test.asm' line 143: illegal DMA command
Error at file 'test.asm' line 144: illegal DMA command
Error at file 'test.asm' line 145: illegal DMA command
Error at file 'test.asm' line 146: illegal DMA command
Error at file 'test.asm' line 147: illegal DMA command
Error at file 'test.asm' line 148: illegal DMA command
Error at file 'test.asm' line 149: illegal DMA command
Error at file 'test.asm' line 150: illegal DMA command
Error at file 'test.asm' line 151: illegal DMA command
Error at file 'test.asm' line 152: illegal DMA command
Error at file 'test.asm' line 153: illegal DMA command
Error at file 'test.asm' line 154: illegal DMA command
Error at file 'test.asm' line 155: illegal DMA command
Error at file 'test.asm' line 156: illegal DMA command
Error at file 'test.asm' line 157: illegal DMA command
Error at file 'test.asm' line 158: illegal DMA command
Error at file 'test.asm' line 159: illegal DMA command
Error at file 'test.asm' line 160: illegal DMA command
Error at file 'test.asm' line 161: illegal DMA command
Error at file 'test.asm' line 162: illegal DMA command
Error at file 'test.asm' line 163: illegal DMA command
Error at file 'test.asm' line 164: illegal DMA command
Error at file 'test.asm' line 165: illegal DMA command
Error at file 'test.asm' line 166: illegal DMA command
Error at file 'test.asm' line 167: illegal DMA command
Error at file 'test.asm' line 168: illegal DMA command
Error at file 'test.asm' line 169: illegal DMA command
Error at file 'test.asm' line 170: illegal DMA command
Error at file 'test.asm' line 171: illegal DMA command
Error at file 'test.asm' line 172: illegal DMA command
Error at file 'test.asm' line 173: illegal DMA command
Error at file 'test.asm' line 174: illegal DMA command
Error at file 'test.asm' line 175: illegal DMA command
Error at file 'test.asm' line 176: illegal DMA command
Error at file 'test.asm' line 177: illegal DMA command
Error at file 'test.asm' line 178: illegal DMA command
Error at file 'test.asm' line 179: illegal DMA command
Error at file 'test.asm' line 180: illegal DMA command
Error at file 'test.asm' line 181: illegal DMA command
Error at file 'test.asm' line 182: illegal DMA command
Error at file 'test.asm' line 183: illegal DMA command
Error at file 'test.asm' line 184: illegal DMA command
Error at file 'test.asm' line 185: illegal DMA command
Error at file 'test.asm' line 186: illegal DMA command
Error at file 'test.asm' line 187: illegal DMA command
Error at file 'test.asm' line 188: illegal DMA command
Error at file 'test.asm' line 189: illegal DMA command
Error at file 'test.asm' line 190: illegal DMA command
Error at file 'test.asm' line 191: illegal DMA command
Error at file 'test.asm' line 192: illegal DMA command
Error at file 'test.asm' line 193: illegal DMA command
Error at file 'test.asm' line 194: illegal DMA command
Error at file 'test.asm' line 195: illegal DMA command
Error at file 'test.asm' line 196: illegal DMA command
Error at file 'test.asm' line 197: illegal DMA command
Error at file 'test.asm' line 198: illegal DMA command
Error at file 'test.asm' line 199: illegal DMA command
Error at file 'test.asm' line 200: illegal DMA command
Error at file 'test.asm' line 201: illegal DMA command
Error at file 'test.asm' line 202: illegal DMA command
Error at file 'test.asm' line 203: illegal DMA command
Error at file 'test.asm' line 204: illegal DMA command
Error at file 'test.asm' line 205: illegal DMA command
Error at file 'test.asm' line 206: illegal DMA command
Error at file 'test.asm' line 207: illegal DMA command
Error at file 'test.asm' line 208: illegal DMA command
Error at file 'test.asm' line 209: illegal DMA command
Error at file 'test.asm' line 210: illegal DMA command
Error at file 'test.asm' line 211: illegal DMA command
Error at file 'test.asm' line 212: illegal DMA command
Error at file 'test.asm' line 213: illegal DMA command
Error at file 'test.asm' line 214: illegal DMA command
Error at file 'test.asm' line 215: illegal DMA command
Error at file 'test.asm' line 216: illegal DMA command
Error at file 'test.asm' line 217: illegal DMA command
Error at file 'test.asm' line 218: illegal DMA command
Error at file 'test.asm' line 219: illegal DMA command
Error at file 'test.asm' line 220: illegal DMA command
Error at file 'test.asm' line 221: illegal DMA command
Error at file 'test.asm' line 222: illegal DMA command
Error at file 'test.asm' line 223: illegal DMA command
Error at file 'test.asm' line 224: illegal DMA command
Error at file 'test.asm' line 225: illegal DMA command
Error at file 'test.asm' line 226: illegal DMA command
Error at file 'test.asm' line 227: illegal DMA command
Error at file 'test.asm' line 228: illegal DMA command
Error at file 'test.asm' line 229: illegal DMA command
Error at file 'test.asm' line 230: illegal DMA command
Error at file 'test.asm' line 231: illegal DMA command
Error at file 'test.asm' line 232: illegal DMA command
Error at file 'test.asm' line 233: illegal DMA command
Error at file 'test.asm' line 234: illegal DMA command
Error at file 'test.asm' line 235: illegal DMA command
Error at file 'test.asm' line 236: illegal DMA command
Error at file 'test.asm' line 237: illegal DMA command
Error at file 'test.asm' line 238: illegal DMA command
Error at file 'test.asm' line 239: illegal DMA command
Error at file 'test.asm' line 240: illegal DMA command
Error at file 'test.asm' line 241: illegal DMA command
Error at file 'test.asm' line 242: illegal DMA command
Error at file 'test.asm' line 243: illegal DMA command
Error at file 'test.asm' line 244: illegal DMA command
Error at file 'test.asm' line 245: illegal DMA command
Error at file 'test.asm' line 246: illegal DMA command
Error at file 'test.asm' line 247: illegal DMA command
Error at file 'test.asm' line 248: illegal DMA command
Error at file 'test.asm' line 249: illegal DMA command
Error at file 'test.asm' line 250: illegal DMA command
Error at file 'test.asm' line 251: illegal DMA command
Error at file 'test.asm' line 252: illegal DMA command
Error at file 'test.asm' line 253: illegal DMA command
Error at file 'test.asm' line 254: illegal DMA command
Error at file 'test.asm' line 255: illegal DMA command
Error at file 'test.asm' line 256: illegal DMA command
Error at file 'test.asm' line 257: illegal DMA command
Error at file 'test.asm' line 258: illegal DMA command
Error at file 'test.asm' line 259: illegal DMA command
Error at file 'test.asm' line 260: illegal DMA command
Error at file 'test.asm' line 261: illegal DMA command
Error at file 'test.asm' line 262: illegal DMA command
Error at file 'test.asm' line 263: illegal DMA command
Error at file 'test.asm' line 264: illegal DMA command
Error at file 'test.asm' line 265: illegal DMA command
Error at file 'test.asm' line 266: illegal DMA command
Error at file 'test.asm' line 267: illegal DMA command
Error at file 'test.asm' line 268: illegal DMA command
Error at file 'test.asm' line 269: illegal DMA command
Error at file 'test.asm' line 270: illegal DMA command
Error at file 'test.asm' line 271: illegal DMA command
Error at file 'test.asm' line 272: illegal DMA command
Error at file 'test.asm' line 273: illegal DMA command
Error at file 'test.asm' line 274: illegal DMA command
Error at file 'test.asm' line 275: illegal DMA command
Error at file 'test.asm' line 276: illegal DMA command
Error at file 'test.asm' line 277: illegal DMA command
Error at file 'test.asm' line 278: illegal DMA command
Error at file 'test.asm' line 279: illegal DMA command
Error at file 'test.asm' line 280: illegal DMA command
Error at file 'test.asm' line 281: illegal DMA command
Error at file 'test.asm' line 282: illegal DMA command
Error at file 'test.asm' line 283: illegal DMA command
Error at file 'test.asm' line 284: illegal DMA command
Error at file 'test.asm' line 285: illegal DMA command
Error at file 'test.asm' line 286: illegal DMA command
Error at file 'test.asm' line 287: illegal DMA command
Error at file 'test.asm' line 288: illegal DMA command
Error at file 'test.asm' line 289: illegal DMA command
Error at file 'test.asm' line 290: illegal DMA command
Error at file 'test.asm' line 291: illegal DMA command
Error at file 'test.asm' line 292: illegal DMA command
Error at file 'test.asm' line 293: illegal DMA command
Error at file 'test.asm' line 294: illegal DMA command
Error at file 'test.asm' line 295: illegal DMA command
Error at file 'test.asm' line 296: illegal DMA command
Error at file 'test.asm' line 297: illegal DMA command
Error at file 'test.asm' line 298: illegal DMA command
Error at file 'test.asm' line 299: illegal DMA command
Error at file 'test.asm' line 300: illegal DMA command
Error at file 'test.asm' line 301: illegal DMA command
Error at file 'test.asm' line 302: illegal DMA command
Error at file 'test.asm' line 303: illegal DMA command
Error at file 'test.asm' line 304: illegal DMA command
Error at file 'test.asm' line 305: illegal DMA command
Error at file 'test.asm' line 306: illegal DMA command
Error at file 'test.asm' line 307: illegal DMA command
Error at file 'test.asm' line 308: illegal DMA command
Error at file 'test.asm' line 309: illegal DMA command
Error at file 'test.asm' line 310: illegal DMA command
Error at file 'test.asm' line 311: illegal DMA command
Error at file 'test.asm' line 312: illegal DMA command
Error at file 'test.asm' line 313: illegal DMA command
Error at file 'test.asm' line 314: illegal DMA command
Error at file 'test.asm' line 315: illegal DMA command
Error at file 'test.asm' line 316: illegal DMA command
Error at file 'test.asm' line 317: illegal DMA command
Error at file 'test.asm' line 318: illegal DMA command
Error at file 'test.asm' line 319: illegal DMA command
Error at file 'test.asm' line 320: illegal DMA command
Error at file 'test.asm' line 321: illegal DMA command
Error at file 'test.asm' line 322: illegal DMA command
Error at file 'test.asm' line 323: illegal DMA command
Error at file 'test.asm' line 324: illegal DMA command
Error at file 'test.asm' line 325: illegal DMA command
Error at file 'test.asm' line 326: illegal DMA command
Error at file 'test.asm' line 327: illegal DMA command
Error at file 'test.asm' line 328: illegal DMA command
Error at file 'test.asm' line 329: illegal DMA command
Error at file 'test.asm' line 330: illegal DMA command
Error at file 'test.asm' line 331: illegal DMA command
Error at file 'test.asm' line 332: illegal DMA command
Error at file 'test.asm' line 333: illegal DMA command
Error at file 'test.asm' line 334: illegal DMA command
Error at file 'test.asm' line 335: illegal DMA command
Error at file 'test.asm' line 336: illegal DMA command
Error at file 'test.asm' line 337: illegal DMA command
Error at file 'test.asm' line 338: illegal DMA command
Error at file 'test.asm' line 339: illegal DMA command
Error at file 'test.asm' line 340: illegal DMA command
Error at file 'test.asm' line 341: illegal DMA command
Error at file 'test.asm' line 342: illegal DMA command
Error at file 'test.asm' line 343: illegal DMA command
Error at file 'test.asm' line 344: illegal DMA command
Error at file 'test.asm' line 345: illegal DMA command
Error at file 'test.asm' line 346: illegal DMA command
Error at file 'test.asm' line 347: illegal DMA command
Error at file 'test.asm' line 348: illegal DMA command
Error at file 'test.asm' line 349: illegal DMA command
Error at file 'test.asm' line 350: illegal DMA command
Error at file 'test.asm' line 351: illegal DMA command
Error at file 'test.asm' line 352: illegal DMA command
Error at file 'test.asm' line 353: illegal DMA command
Error at file 'test.asm' line 354: illegal DMA command
Error at file 'test.asm' line 355: illegal DMA command
Error at file 'test.asm' line 356: illegal DMA command
Error at file 'test.asm' line 357: illegal DMA command
Error at file 'test.asm' line 358: illegal DMA command
Error at file 'test.asm' line 359: illegal DMA command
Error at file 'test.asm' line 360: illegal DMA command
Error at file 'test.asm' line 361: illegal DMA command
Error at file 'test.asm' line 362: illegal DMA command
Error at file 'test.asm' line 363: illegal DMA command
Error at file 'test.asm' line 364: illegal DMA command
Error at file 'test.asm' line 365: illegal DMA command
Error at file 'test.asm' line 366: illegal DMA command
Error at file 'test.asm' line 367: illegal DMA command
Error at file 'test.asm' line 368: illegal DMA command
Error at file 'test.asm' line 369: illegal DMA command
Error at file 'test.asm' line 370: illegal DMA command
Error at file 'test.asm' line 371: illegal DMA command
Error at file 'test.asm' line 372: illegal DMA command
Error at file 'test.asm' line 373: illegal DMA command
Error at file 'test.asm' line 374: illegal DMA command
Error at file 'test.asm' line 375: illegal DMA command
Error at file 'test.asm' line 376: illegal DMA command
Error at file 'test.asm' line 377: illegal DMA command
Error at file 'test.asm' line 378: illegal DMA command
Error at file 'test.asm' line 379: illegal DMA command
Error at file 'test.asm' line 380: illegal DMA command
Error at file 'test.asm' line 381: illegal DMA command
Error at file 'test.asm' line 382: illegal DMA command
Error at file 'test.asm' line 383: illegal DMA command
Error at file 'test.asm' line 384: illegal DMA command
Error at file 'test.asm' line 385: illegal DMA command
Error at file 'test.asm' line 386: illegal DMA command
Error at file 'test.asm' line 387: illegal DMA command
Error at file 'test.asm' line 388: illegal DMA command
Error at file 'test.asm' line 389: illegal DMA command
Error at file 'test.asm' line 390: illegal DMA command
Error at file 'test.asm' line 391: illegal DMA command
Error at file 'test.asm' line 392: illegal DMA command
Error at file 'test.asm' line 393: illegal DMA command
Error at file 'test.asm' line 394: illegal DMA command
Error at file 'test.asm' line 395: illegal DMA command
Error at file 'test.asm' line 396: illegal DMA command
Error at file 'test.asm' line 397: illegal DMA command
Error at file 'test.asm' line 398: illegal DMA command
Error at file 'test.asm' line 399: illegal DMA command
Error at file 'test.asm' line 400: illegal DMA command
Error at file 'test.asm' line 401: illegal DMA command
Error at file 'test.asm' line 402: illegal DMA command
Error at file 'test.asm' line 403: illegal DMA command
Error at file 'test.asm' line 404: illegal DMA command
Error at file 'test.asm' line 405: illegal DMA command
Error at file 'test.asm' line 406: illegal DMA command
Error at file 'test.asm' line 407: illegal DMA command
Error at file 'test.asm' line 408: illegal DMA command
Error at file 'test.asm' line 409: illegal DMA command
Error at file 'test.asm' line 410: illegal DMA command
Error at file 'test.asm' line 411: illegal DMA command
Error at file 'test.asm' line 412: illegal DMA command
Error at file 'test.asm' line 413: illegal DMA command
Error at file 'test.asm' line 414: illegal DMA command
Error at file 'test.asm' line 415: illegal DMA command
Error at file 'test.asm' line 416: illegal DMA command
Error at file 'test.asm' line 417: illegal DMA command
Error at file 'test.asm' line 418: illegal DMA command
Error at file 'test.asm' line 419: illegal DMA command
Error at file 'test.asm' line 420: illegal DMA command
Error at file 'test.asm' line 421: illegal DMA command
Error at file 'test.asm' line 422: illegal DMA command
Error at file 'test.asm' line 423: illegal DMA command
Error at file 'test.asm' line 424: illegal DMA command
Error at file 'test.asm' line 425: illegal DMA command
Error at file 'test.asm' line 426: illegal DMA command
Error at file 'test.asm' line 427: illegal DMA command
Error at file 'test.asm' line 428: illegal DMA command
Error at file 'test.asm' line 429: illegal DMA command
Error at file 'test.asm' line 430: illegal DMA command
Error at file 'test.asm' line 431: illegal DMA command
Error at file 'test.asm' line 432: illegal DMA command
Error at file 'test.asm' line 433: illegal DMA command
Error at file 'test.asm' line 434: illegal DMA command
Error at file 'test.asm' line 435: illegal DMA command
Error at file 'test.asm' line 436: illegal DMA command
Error at file 'test.asm' line 437: illegal DMA command
Error at file 'test.asm' line 438: illegal DMA command
Error at file 'test.asm' line 439: illegal DMA command
Error at file 'test.asm' line 440: illegal DMA command
Error at file 'test.asm' line 441: illegal DMA command
Error at file 'test.asm' line 442: illegal DMA command
Error at file 'test.asm' line 443: illegal DMA command
Error at file 'test.asm' line 444: illegal DMA command
Error at file 'test.asm' line 445: illegal DMA command
Error at file 'test.asm' line 446: illegal DMA command
Error at file 'test.asm' line 447: illegal DMA command
Error at file 'test.asm' line 448: illegal DMA command
Error at file 'test.asm' line 449: illegal DMA command
Error at file 'test.asm' line 450: illegal DMA command
Error at file 'test.asm' line 451: illegal DMA command
Error at file 'test.asm' line 452: illegal DMA command
Error at file 'test.asm' line 453: illegal DMA command
Error at file 'test.asm' line 454: illegal DMA command
Error at file 'test.asm' line 455: illegal DMA command
Error at file 'test.asm' line 456: illegal DMA command
Error at file 'test.asm' line 457: illegal DMA command
Error at file 'test.asm' line 458: illegal DMA command
Error at file 'test.asm' line 459: illegal DMA command
Error at file 'test.asm' line 460: illegal DMA command
Error at file 'test.asm' line 461: illegal DMA command
Error at file 'test.asm' line 462: illegal DMA command
Error at file 'test.asm' line 463: illegal DMA command
Error at file 'test.asm' line 464: illegal DMA command
Error at file 'test.asm' line 465: illegal DMA command
Error at file 'test.asm' line 466: illegal DMA command
Error at file 'test.asm' line 467: illegal DMA command
Error at file 'test.asm' line 468: illegal DMA command
Error at file 'test.asm' line 469: illegal DMA command
Error at file 'test.asm' line 470: illegal DMA command
Error at file 'test.asm' line 471: illegal DMA command
Error at file 'test.asm' line 472: illegal DMA command
Error at file 'test.asm' line 473: illegal DMA command
Error at file 'test.asm' line 474: illegal DMA command
Error at file 'test.asm' line 475: illegal DMA command
Error at file 'test.asm' line 476: illegal DMA command
Error at file 'test.asm' line 477: illegal DMA command
Error at file 'test.asm' line 478: illegal DMA command
Error at file 'test.asm' line 479: illegal DMA command
Error at file 'test.asm' line 480: illegal DMA command
Error at file 'test.asm' line 481: illegal DMA command
ERR

z80asm(<<'ASM', "-b -mz80n", 0, "", "");
	ld a,1
	
	dma.wr6 0x83
	dma.wr6 0x87
	dma.wr6 0xCF
	dma.wr6 0xD3
	
	dma.cmd 0x83
	dma.cmd 0x87
	dma.cmd 0xCF
	dma.cmd 0xD3
	
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0x83,
				0x87,
				0xCF,
				0xD3,
				0x83,
				0x87,
				0xCF,
				0xD3,
				0x3E, 2));

z80asm(<<'ASM', "-b -mz80n", 0, "", <<'WARN');
	ld a,1
	
	dma.wr6 0xC3
	dma.wr6 0xC7
	dma.wr6 0xCB
	dma.wr6 0xAF
	dma.wr6 0xAB
	dma.wr6 0xA3
	dma.wr6 0xB7
	dma.wr6 0xBF
	dma.wr6 0x8B 
	dma.wr6 0xA7
	dma.wr6 0xB3
	
	dma.cmd 0xC3
	dma.cmd 0xC7
	dma.cmd 0xCB
	dma.cmd 0xAF
	dma.cmd 0xAB
	dma.cmd 0xA3
	dma.cmd 0xB7
	dma.cmd 0xBF
	dma.cmd 0x8B 
	dma.cmd 0xA7
	dma.cmd 0xB3
	
	ld a,2
ASM
Warning at file 'test.asm' line 3: DMA does not implement this command
Warning at file 'test.asm' line 4: DMA does not implement this command
Warning at file 'test.asm' line 5: DMA does not implement this command
Warning at file 'test.asm' line 6: DMA does not implement this command
Warning at file 'test.asm' line 7: DMA does not implement this command
Warning at file 'test.asm' line 8: DMA does not implement this command
Warning at file 'test.asm' line 9: DMA does not implement this command
Warning at file 'test.asm' line 10: DMA does not implement this command
Warning at file 'test.asm' line 11: DMA does not implement this command
Warning at file 'test.asm' line 12: DMA does not implement this command
Warning at file 'test.asm' line 13: DMA does not implement this command
Warning at file 'test.asm' line 15: DMA does not implement this command
Warning at file 'test.asm' line 16: DMA does not implement this command
Warning at file 'test.asm' line 17: DMA does not implement this command
Warning at file 'test.asm' line 18: DMA does not implement this command
Warning at file 'test.asm' line 19: DMA does not implement this command
Warning at file 'test.asm' line 20: DMA does not implement this command
Warning at file 'test.asm' line 21: DMA does not implement this command
Warning at file 'test.asm' line 22: DMA does not implement this command
Warning at file 'test.asm' line 23: DMA does not implement this command
Warning at file 'test.asm' line 24: DMA does not implement this command
Warning at file 'test.asm' line 25: DMA does not implement this command
WARN
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0xC3,
				0xC7,
				0xCB,
				0xAF,
				0xAB,
				0xA3,
				0xB7,
				0xBF,
				0x8B, 
				0xA7,
				0xB3,
				0xC3,
				0xC7,
				0xCB,
				0xAF,
				0xAB,
				0xA3,
				0xB7,
				0xBF,
				0x8B, 
				0xA7,
				0xB3,
				0x3E, 2));

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	ld a,1
	dma.wr6 0xBB
	dma.cmd 0xBB
	ld a,2
ASM
Error at file 'test.asm' line 2: DMA missing register group member(s)
Error at file 'test.asm' line 3: DMA missing register group member(s)
ERR

z80asm(<<'ASM', "-b -mz80n", 0, "", "");
	ld a,1
	dma.wr6 0xBB, 0x7F
	dma.cmd 0xBB, 0x7F
	ld a,2
ASM
check_bin_file("test.bin", pack("C*", 
				0x3E, 1, 
				0xBB, 0x7F,
				0xBB, 0x7F,
				0x3E, 2));

z80asm(<<'ASM', "-b -mz80n", 1, "", <<'ERR');
	ld a,1
	dma.wr6 0xBB, 0x80
	dma.cmd 0xBB, 0x80
	ld a,2
ASM
Error at file 'test.asm' line 2: DMA read mask is illegal
Error at file 'test.asm' line 3: DMA read mask is illegal
ERR

unlink_testfiles();
done_testing();
