#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		phase -1
END_ASM
$test.asm:1: error: integer range: -1
  ^---- phase -1
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		phase 65536
END_ASM
$test.asm:1: error: integer range: 0x10000
  ^---- phase 65536
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		phase x
END_ASM
$test.asm:1: error: undefined symbol: x
  ^---- phase x
$test.asm:1: error: constant expression expected
  ^---- phase x
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		extern x
		phase x
END_ASM
$test.asm:2: error: constant expression expected
  ^---- phase x
END_ERR

z80asm_ok("-b -m -l", "", "", <<END,
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
	bytes(0x21, 18, 0,
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

check_txt_file("$test.lis", <<'END');
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
27    001C              
END

check_txt_file("$test.map", <<END);
part1                           = \$0000 ; addr, local, , $test, PART_1, $test.asm:2
start                           = \$0012 ; addr, local, , $test, PART_1, $test.asm:11
end                             = \$001A ; addr, local, , $test, PART_1, $test.asm:24
l1                              = \$000D ; addr, local, , $test, PART_1, $test.asm:8
f2                              = \$8003 ; const, local, , $test, PART_1, $test.asm:14
f1                              = \$8000 ; const, local, , $test, PART_1, $test.asm:13
l2                              = \$8005 ; const, local, , $test, PART_1, $test.asm:21
part2                           = \$001C ; addr, local, , $test, PART_2, $test.asm:17
__head                          = \$0000 ; const, public, def, , ,
__tail                          = \$0020 ; const, public, def, , ,
__size                          = \$0020 ; const, public, def, , ,
__PART_1_head                   = \$0000 ; const, public, def, , ,
__PART_1_tail                   = \$001C ; const, public, def, , ,
__PART_1_size                   = \$001C ; const, public, def, , ,
__PART_2_head                   = \$001C ; const, public, def, , ,
__PART_2_tail                   = \$0020 ; const, public, def, , ,
__PART_2_size                   = \$0004 ; const, public, def, , ,
END

unlink_testfiles;
done_testing;
