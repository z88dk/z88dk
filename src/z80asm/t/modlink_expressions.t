#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

#------------------------------------------------------------------------------
# Test expressions across modules
unlink_testfiles;

spew("${test}.asm", <<'END');
			org $1234

			public a1
			extern a2, __head, __tail, __size
	a0:
			ld	a, ASMPC -$1200	;$1234 ;; 3E 34
			jp	ASMPC			;$1236 ;; C3 36 12
			ld	b, a1 -$1200	;$1239 ;; 06 47
			jp	a1				;$123B ;; C3 47 12
			ld	hl, a2 - a1		;$123E ;; 21 1C 00
			ld	bc, a1 - ASMPC	;$1241 ;; 01 06 00
			ld	de, a2 - ASMPC	;$1244 ;; 11 1F 00
	a1:							;$1247
			ld	hl, __head		;$1247 ;; 21 34 12
			ld	de, __tail		;$124A ;; 11 6C 12
			ld	bc, __size		;$124D ;; 01 38 00
								;$1250
END

spew("${test}1.asm", <<'END');
			public a2
			extern a1, __head, __tail, __size

			ld	a, ASMPC -$1200	;$1250 ;; 3E 50
			jp	ASMPC			;$1252 ;; C3 52 12
			ld	b, a2 -$1200	;$1255 ;; 06 63
			jp	a2				;$1257 ;; C3 63 12
			ld	hl, a2 - a1		;$125A ;; 21 1C 00
			ld	bc, ASMPC - a1	;$125D ;; 01 16 00
			ld	de, a2 - ASMPC	;$1260 ;; 11 03 00
	a2:							;$1263
			ld	hl, __head		;$1263 ;; 21 34 12
			ld	de, __tail		;$1266 ;; 11 6C 12
			ld	bc, __size		;$1269 ;; 01 38 00
								;$126C
END

my $bin = bytes(
	0x3E, 0x34,
	0xC3, 0x36, 0x12,
	0x06, 0x47,
	0xC3, 0x47, 0x12,
	0x21, 0x1C, 0x00,
	0x01, 0x06, 0x00,
	0x11, 0x1F, 0x00,
	
	0x21, 0x34, 0x12,
	0x11, 0x6C, 0x12,
	0x01, 0x38, 0x00,
	
	0x3E, 0x50,
	0xC3, 0x52, 0x12,
	0x06, 0x63,
	0xC3, 0x63, 0x12,
	0x21, 0x1C, 0x00,
	0x01, 0x16, 0x00,
	0x11, 0x03, 0x00,
	
	0x21, 0x34, 0x12,
	0x11, 0x6C, 0x12,
	0x01, 0x38, 0x00,
);

# assemble and link
unlink("${test}.bin");
capture_ok("z88dk-z80asm -b -l -m ${test}.asm ${test}1.asm", "");
check_bin_file("${test}.bin", $bin);

# link only
unlink("${test}.bin");
capture_ok("z88dk-z80asm -b -l -m ${test}.o ${test}1.o", "");
check_bin_file("${test}.bin", $bin);

capture_ok("z88dk-z80nm -a ${test}.o ${test}1.o", <<END);
Object  file ${test}.o at \$0000: Z80RMF16
  Name: ${test}
  Section "": 28 bytes, ORG \$1234
    C \$0000: 3E 00 C3 00 00 06 00 C3 00 00 21 00 00 01 00 00
    C \$0010: 11 00 00 21 00 00 11 00 00 01 00 00
  Symbols:
    L A \$0000 a0 (section "") (file ${test}.asm:5)
    G A \$0013 a1 (section "") (file ${test}.asm:13)
  Externs:
    U         a2
    U         __head
    U         __tail
    U         __size
  Expressions:
    E Ub \$0000 \$0001: \$-4608 (section "") (file ${test}.asm:6)
    E Cw \$0002 \$0003: \$ (section "") (file ${test}.asm:7)
    E Ub \$0005 \$0006: a1-4608 (section "") (file ${test}.asm:8)
    E Cw \$0007 \$0008: a1 (section "") (file ${test}.asm:9)
    E Cw \$000A \$000B: a2-a1 (section "") (file ${test}.asm:10)
    E Cw \$000D \$000E: a1-\$ (section "") (file ${test}.asm:11)
    E Cw \$0010 \$0011: a2-\$ (section "") (file ${test}.asm:12)
    E Cw \$0013 \$0014: __head (section "") (file ${test}.asm:14)
    E Cw \$0016 \$0017: __tail (section "") (file ${test}.asm:15)
    E Cw \$0019 \$001A: __size (section "") (file ${test}.asm:16)
Object  file ${test}1.o at \$0000: Z80RMF16
  Name: ${test}1
  Section "": 28 bytes, ORG \$1234
    C \$0000: 3E 00 C3 00 00 06 00 C3 00 00 21 00 00 01 00 00
    C \$0010: 11 00 00 21 00 00 11 00 00 01 00 00
  Symbols:
    G A \$0013 a2 (section "") (file ${test}1.asm:11)
  Externs:
    U         a1
    U         __head
    U         __tail
    U         __size
  Expressions:
    E Ub \$0000 \$0001: \$-4608 (section "") (file ${test}1.asm:4)
    E Cw \$0002 \$0003: \$ (section "") (file ${test}1.asm:5)
    E Ub \$0005 \$0006: a2-4608 (section "") (file ${test}1.asm:6)
    E Cw \$0007 \$0008: a2 (section "") (file ${test}1.asm:7)
    E Cw \$000A \$000B: a2-a1 (section "") (file ${test}1.asm:8)
    E Cw \$000D \$000E: \$-a1 (section "") (file ${test}1.asm:9)
    E Cw \$0010 \$0011: a2-\$ (section "") (file ${test}1.asm:10)
    E Cw \$0013 \$0014: __head (section "") (file ${test}1.asm:12)
    E Cw \$0016 \$0017: __tail (section "") (file ${test}1.asm:13)
    E Cw \$0019 \$001A: __size (section "") (file ${test}1.asm:14)
END

check_text_file("${test}.map", <<END);
a0                              = \$1234 ; addr, local, , ${test}, , ${test}.asm:5
a1                              = \$1247 ; addr, public, , ${test}, , ${test}.asm:13
a2                              = \$1263 ; addr, public, , ${test}1, , ${test}1.asm:11
__head                          = \$1234 ; const, public, def, , ,
__tail                          = \$126C ; const, public, def, , ,
__size                          = \$0038 ; const, public, def, , ,
END


#------------------------------------------------------------------------------
# Use before external declaration
# declare before define
unlink_testfiles;

spew("${test}.asm", <<'END');
			PUBLIC func1
			EXTERN func2
	func1:	call func2
			ret
END

spew("${test}1.asm", <<'END');
			PUBLIC func2
			EXTERN func1
	func2:	call func1
			ret
END

$bin = bytes(0xCD, 0x04, 0x10,	# @ 0x1000 : func1
			 0xC9,				# @ 0x1003
			 0xCD, 0x00, 0x10,	# @ 0x1004 : func2
			 0xC9,				# @ 0x1007
);

# assemble and link
unlink("${test}.bin");
capture_ok("z88dk-z80asm -r0x1000 -b ${test}.asm ${test}1.asm", "");
check_bin_file("${test}.bin", $bin);

# link only
unlink("${test}.bin");
capture_ok("z88dk-z80asm -b ${test}.o ${test}1.o", "");
check_bin_file("${test}.bin", $bin);

capture_ok("z88dk-z80nm -a ${test}.o ${test}1.o", <<END);
Object  file ${test}.o at \$0000: Z80RMF16
  Name: ${test}
  Section "": 4 bytes, ORG \$1000
    C \$0000: CD 00 00 C9
  Symbols:
    G A \$0000 func1 (section "") (file ${test}.asm:3)
  Externs:
    U         func2
  Expressions:
    E Cw \$0000 \$0001: func2 (section "") (file ${test}.asm:3)
Object  file ${test}1.o at \$0000: Z80RMF16
  Name: ${test}1
  Section "": 4 bytes, ORG \$1000
    C \$0000: CD 00 00 C9
  Symbols:
    G A \$0000 func2 (section "") (file ${test}1.asm:3)
  Externs:
    U         func1
  Expressions:
    E Cw \$0000 \$0001: func1 (section "") (file ${test}1.asm:3)
END


#------------------------------------------------------------------------------
# Use before external declaration
# define before declare
unlink_testfiles;

spew("${test}.asm", <<'END');
	func1:	call func2
			ret
			PUBLIC func1
			EXTERN func2
END

spew("${test}1.asm", <<'END');
	func2:	call func1
			ret
			PUBLIC func2
			EXTERN func1
END

$bin = bytes(0xCD, 0x04, 0x10,	# @ 0x1000 : func1
			 0xC9,				# @ 0x1003
			 0xCD, 0x00, 0x10,	# @ 0x1004 : func2
			 0xC9,				# @ 0x1007
);

# assemble and link
unlink("${test}.bin");
capture_ok("z88dk-z80asm -r0x1000 -b ${test}.asm ${test}1.asm", "");
check_bin_file("${test}.bin", $bin);

# link only
unlink("${test}.bin");
capture_ok("z88dk-z80asm -b ${test}.o ${test}1.o", "");
check_bin_file("${test}.bin", $bin);

capture_ok("z88dk-z80nm -a ${test}.o ${test}1.o", <<END);
Object  file ${test}.o at \$0000: Z80RMF16
  Name: ${test}
  Section "": 4 bytes, ORG \$1000
    C \$0000: CD 00 00 C9
  Symbols:
    G A \$0000 func1 (section "") (file ${test}.asm:1)
  Externs:
    U         func2
  Expressions:
    E Cw \$0000 \$0001: func2 (section "") (file ${test}.asm:1)
Object  file ${test}1.o at \$0000: Z80RMF16
  Name: ${test}1
  Section "": 4 bytes, ORG \$1000
    C \$0000: CD 00 00 C9
  Symbols:
    G A \$0000 func2 (section "") (file ${test}1.asm:1)
  Externs:
    U         func1
  Expressions:
    E Cw \$0000 \$0001: func1 (section "") (file ${test}1.asm:1)
END


#------------------------------------------------------------------------------
# Declare label as public, use it in an expression and dont define it: 
# caused a crash
unlink_testfiles;

z80asm_nok("", "", <<ASM, <<ERR);
		PUBLIC	sd_write_block_2gb
		EXTERN	ASMDISP_SD_WRITE_BLOCK_2GB_CALLEE

	sd_write_sector:
		jp sd_write_block_2gb + ASMDISP_SD_WRITE_BLOCK_2GB_CALLEE ;; error: undefined symbol: sd_write_block_2gb
ASM
${test}.asm:5: error: undefined symbol: sd_write_block_2gb
  ^---- sd_write_block_2gb+ASMDISP_SD_WRITE_BLOCK_2GB_CALLEE
${test}.asm:1: error: undefined symbol: sd_write_block_2gb
ERR



unlink_testfiles;
done_testing;
