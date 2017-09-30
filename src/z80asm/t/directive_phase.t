#!/usr/bin/perl

# Z88DK Z80 Module Assembler
#
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test PHASE/DEPHASE

use strict;
use warnings;
use v5.10;
use Test::More;
require './t/testlib.pl';

unlink_testfiles();
z80asm("phase -1", "", 1, "", <<'END');
Error at file 'test.asm' line 1: integer '-1' out of range
1 errors occurred during assembly
END

z80asm("phase 65536", "", 1, "", <<'END');
Error at file 'test.asm' line 1: integer '65536' out of range
1 errors occurred during assembly
END

z80asm("phase x", "", 1, "", <<'END');
Error at file 'test.asm' line 1: symbol 'x' not defined
1 errors occurred during assembly
END

unlink_testfiles();
z80asm(<<'END', "-b -m -l");
	init:
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
));
check_text_file("test.lis", <<'END');
1     0000              	init:
2     0000  21 12 00    		ld hl, start
3     0003  11 00 80    		ld de, 0x8000
4     0006  01 08 00    		ld bc, end-start
5     0009  ED B0       		ldir
6     000B  18 00       		jr l1
7     000D              	l1:
8     000D  C3 00 80    		jp 0x8000
9     0010  10 00       		defw asmpc
10    0012              	start:
11    0012              		PHASE 0x8000
12    8000  CD 03 80    	f1: call f2
13    8003  18 00       	f2: jr l2
14    8005  C9          	l2:	ret
15    8006  06 80       		defw asmpc
16    8008              		DEPHASE
17    001A              	end:
18    001A  1A 00       		defw asmpc
19    001C              
END

check_text_file("test.map", <<'END');
	init	= $0000 ; addr, local, , test, , test.asm:1
	start   = $0012 ; addr, local, , test, , test.asm:10
	end     = $001A ; addr, local, , test, , test.asm:17
	l1      = $000D ; addr, local, , test, , test.asm:7
	f2      = $8003 ; const, local, , test, , test.asm:13
	f1      = $8000 ; const, local, , test, , test.asm:12
	l2      = $8005 ; const, local, , test, , test.asm:14
	__head  = $0000 ; const, public, def, , ,
	__tail  = $001C ; const, public, def, , ,
	__size  = $001C ; const, public, def, , ,
END

#unlink_testfiles();
done_testing();
