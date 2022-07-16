#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# maximum forward and backward relative jumps
z80asm_ok("", "", "", <<END,
	jr	 jr2
	jr	 jr2
	jr	 jr2
	
	djnz ASMPC
	djnz ASMPC+0x81
	jr	 ASMPC
	jr	 ASMPC-0x7E
	
	djnz jr1
jr1:
	jr    jr1
	djnz  jr1
	jr nc,jr1
	jr c, jr1
	jr nz,jr1
	jr z, jr1
		
	defs 101, 0
	
jr2:
	defs 122, 0
	
	jr	 jr2
	jr	 jr2
	jr	 jr2							;;	defb 18h, 80h
END
	bytes(0x18, 0x7f,
		  0x18, 0x7d, 
		  0x18, 0x7b,
		  
		  0x10, 0xfe,
		  0x10, 0x7f,
		  0x18, 0xfe,
		  0x18, 0x80,
		  
		  0x10, 0,
		  0x18, 0xfe,
		  0x10, 0xfc,
		  0x30, 0xfa, 
		  0x38, 0xf8,
		  0x20, 0xf6,
		  0x28, 0xf4,
		  
		  (0) x 101,
		  (0) x 122,
		  
		  0x18, 0x84,
		  0x18, 0x82,
		  0x18, 0x80));
		  
z80asm_nok("", "", <<END, <<END);
	djnz ASMPC-0x7F	
	djnz ASMPC+0x82	
	jr ASMPC-0x7F	
	jr ASMPC+0x82	
	jr nz,ASMPC-0x7F
	jr nz,ASMPC+0x82
	jr  z,ASMPC-0x7F
	jr  z,ASMPC+0x82
	jr nc,ASMPC-0x7F
	jr nc,ASMPC+0x82
	jr  c,ASMPC-0x7F
	jr  c,ASMPC+0x82
END
$test.asm:1: error: integer range: -129
  ^---- \$-127
$test.asm:2: error: integer range: 0x80
  ^---- \$+130
$test.asm:3: error: integer range: -129
  ^---- \$-127
$test.asm:4: error: integer range: 0x80
  ^---- \$+130
$test.asm:5: error: integer range: -129
  ^---- \$-127
$test.asm:6: error: integer range: 0x80
  ^---- \$+130
$test.asm:7: error: integer range: -129
  ^---- \$-127
$test.asm:8: error: integer range: 0x80
  ^---- \$+130
$test.asm:9: error: integer range: -129
  ^---- \$-127
$test.asm:10: error: integer range: 0x80
  ^---- \$+130
$test.asm:11: error: integer range: -129
  ^---- \$-127
$test.asm:12: error: integer range: 0x80
  ^---- \$+130
END

# Allow labels with names of opcodes
z80asm_ok("", "", "", <<END, bytes(0x18, 0xfe));
	jr: jr jr
END

unlink_testfiles;
done_testing;
