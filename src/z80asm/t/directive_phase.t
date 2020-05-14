#!/usr/bin/perl

# Z88DK Z80 Module Assembler
#
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test PHASE/DEPHASE

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

unlink_testfiles();
z80asm("phase -1", "", 1, "", <<'END');
Error at file 'test.asm' line 1: integer '-1' out of range
END

z80asm("phase 65536", "", 1, "", <<'END');
Error at file 'test.asm' line 1: integer '65536' out of range
END

z80asm("phase x", "", 1, "", <<'END');
Error at file 'test.asm' line 1: symbol 'x' not defined
Error at file 'test.asm' line 1: expected constant expression
END

z80asm("extern x \n phase x", "", 1, "", <<'END');
Error at file 'test.asm' line 2: expected constant expression
END

unlink_testfiles();
z80asm(<<'END', "-b -m -l");
	section PART_1
	part1:
		ld hl, start
		ld de, 0x8000
		ld bc, end-start
		ldir
		jr l1
	l1:
		jp 0x8000
		defw asmpc
	start:
		PHASE 0x8000
	f1: call f2
	f2: jr l2
	
		section PART_2
	part2:
		defb 1,2,3,4
		
		section PART_1
	l2:	ret
		defw asmpc
		DEPHASE
	end:
		defw asmpc
END
check_bin_file("test.bin", pack("C*", 
				0x21, 18, 0,
				0x11, 0, 0x80,
				0x01, 8, 0,
				0xED, 0xB0,
				0x18, 0,
				0xC3, 0, 0x80,
				0x10, 0,
				0xCD, 3, 0x80,
				0x18, 0,
				0xC9,
				0x06, 0x80,
				0x1A, 0,
				1, 2, 3, 4,
));
check_text_file("test.lis", <<'END');
	1     0000              	section PART_1
	2     0000              	part1:
	3     0000  21 12 00    		ld hl, start
	4     0003  11 00 80    		ld de, 0x8000
	5     0006  01 08 00    		ld bc, end-start
	6     0009  ED B0       		ldir
	7     000B  18 00       		jr l1
	8     000D              	l1:
	9     000D  C3 00 80    		jp 0x8000
	10    0010  10 00       		defw asmpc
	11    0012              	start:
	12    0012              		PHASE 0x8000
	13    8000  CD 03 80    	f1: call f2
	14    8003  18 00       	f2: jr l2
	15    8005              
	16    8005              		section PART_2
	17    0000              	part2:
	18    0000  01 02 03 04 		defb 1,2,3,4
	19    0004              
	20    0004              		section PART_1
	21    8005  C9          	l2:	ret
	22    8006  06 80       		defw asmpc
	23    8008              		DEPHASE
	24    001A              	end:
	25    001A  1A 00       		defw asmpc
	26    001C              
END

check_text_file("test.map", <<'END');
	part1                           = $0000 ; addr, local, , test, PART_1, test.asm:2
	start                           = $0012 ; addr, local, , test, PART_1, test.asm:11
	end                             = $001A ; addr, local, , test, PART_1, test.asm:24
	l1                              = $000D ; addr, local, , test, PART_1, test.asm:8
	f2                              = $8003 ; const, local, , test, PART_1, test.asm:14
	f1                              = $8000 ; const, local, , test, PART_1, test.asm:13
	l2                              = $8005 ; const, local, , test, PART_1, test.asm:21
	part2                           = $001C ; addr, local, , test, PART_2, test.asm:17
	__head                          = $0000 ; const, public, def, , ,
	__tail                          = $0020 ; const, public, def, , ,
	__size                          = $0020 ; const, public, def, , ,
	__PART_1_head                   = $0000 ; const, public, def, , ,
	__PART_1_tail                   = $001C ; const, public, def, , ,
	__PART_1_size                   = $001C ; const, public, def, , ,
	__PART_2_head                   = $001C ; const, public, def, , ,
	__PART_2_tail                   = $0020 ; const, public, def, , ,
	__PART_2_size                   = $0004 ; const, public, def, , ,
END

unlink_testfiles();
done_testing();
