#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		phase -1
END_ASM
$test.asm:1: error: integer range: -1
  ^---- phase -1
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		phase 65536
END_ASM
$test.asm:1: error: integer range: \$10000
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

check_text_file("$test.lis", <<'END');
test_t_PHASE.asm:
     1                          	section PART_1
     2                          	part1:
     3  0000  211200            		ld hl, start
     4  0003  110080            		ld de, 0x8000
     5  0006  010800            		ld bc, end-start
     6  0009  edb0              		ldir
     7  000b  1800              		jr l1
     8                          	l1:
     9  000d  c30080            		jp 0x8000
    10  0010  1000              		defw asmpc
    11                          	start:
    12                          		PHASE 0x8000
    13  8000  cd0380            	f1: call f2
    14  8003  1800              	f2: jr l2
    15                          
    16                          		section PART_2
    17                          	part2:
    18  0000  01020304          		defb 1,2,3,4
    19                          
    20                          		section PART_1
    21  8005  c9                	l2:	ret
    22  8006  0680              		defw asmpc
    23                          		DEPHASE
    24                          	end:
    25  001a  1a00              		defw asmpc
    26                          
    27                          
END

check_text_file("$test.map", <<END);
__PART_1_head                   = \$0000 ; const, public, def, , ,
__PART_1_size                   = \$001C ; const, public, def, , ,
__PART_1_tail                   = \$001C ; const, public, def, , ,
__PART_2_head                   = \$001C ; const, public, def, , ,
__PART_2_size                   = \$0004 ; const, public, def, , ,
__PART_2_tail                   = \$0020 ; const, public, def, , ,
__head                          = \$0000 ; const, public, def, , ,
__size                          = \$0020 ; const, public, def, , ,
__tail                          = \$0020 ; const, public, def, , ,
end                             = \$001A ; addr, local, , $test, PART_1, $test.asm:24
f1                              = \$8000 ; const, local, , $test, PART_1, $test.asm:13
f2                              = \$8003 ; const, local, , $test, PART_1, $test.asm:14
l1                              = \$000D ; addr, local, , $test, PART_1, $test.asm:8
l2                              = \$8005 ; const, local, , $test, PART_1, $test.asm:21
part1                           = \$0000 ; addr, local, , $test, PART_1, $test.asm:2
part2                           = \$001C ; addr, local, , $test, PART_2, $test.asm:17
start                           = \$0012 ; addr, local, , $test, PART_1, $test.asm:11
END

unlink_testfiles;
done_testing;
