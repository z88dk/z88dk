#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#
# Test linking of modules

use Modern::Perl;
BEGIN {
	use lib '.';
	use t::TestZ80asm;
};
use Capture::Tiny::Extended 'capture';

#------------------------------------------------------------------------------
# Test expressions across modules
z80asm(
	asm =>	<<'ASM',
			org $1234

			public a1
			extern a2, __head, __tail, __size

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
ASM
	asm1 => <<'ASM1',
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
ASM1
	options => "-b -l"
);
my $bin = read_binfile("test.bin");

# link only
z80asm(
	options => "-d -b -m test.o test1.o",
	bin		=> $bin,
);

z80nm("test.o test1.o", <<'END');
Object  file test.o at $0000: Z80RMF16
  Name: test
  Section "": 28 bytes, ORG $1234
    C $0000: 3E 00 C3 00 00 06 00 C3 00 00 21 00 00 01 00 00
    C $0010: 11 00 00 21 00 00 11 00 00 01 00 00
  Symbols:
    G A $0013 a1 (section "") (file test.asm:13)
  Externs:
    U         a2
    U         __head
    U         __tail
    U         __size
  Expressions:
    E Ub $0000 $0001: $-4608 (section "") (file test.asm:6)
    E Cw $0002 $0003: $ (section "") (file test.asm:7)
    E Ub $0005 $0006: a1-4608 (section "") (file test.asm:8)
    E Cw $0007 $0008: a1 (section "") (file test.asm:9)
    E Cw $000A $000B: a2-a1 (section "") (file test.asm:10)
    E Cw $000D $000E: a1-$ (section "") (file test.asm:11)
    E Cw $0010 $0011: a2-$ (section "") (file test.asm:12)
    E Cw $0013 $0014: __head (section "") (file test.asm:14)
    E Cw $0016 $0017: __tail (section "") (file test.asm:15)
    E Cw $0019 $001A: __size (section "") (file test.asm:16)
Object  file test1.o at $0000: Z80RMF16
  Name: test1
  Section "": 28 bytes, ORG $1234
    C $0000: 3E 00 C3 00 00 06 00 C3 00 00 21 00 00 01 00 00
    C $0010: 11 00 00 21 00 00 11 00 00 01 00 00
  Symbols:
    G A $0013 a2 (section "") (file test1.asm:11)
  Externs:
    U         a1
    U         __head
    U         __tail
    U         __size
  Expressions:
    E Ub $0000 $0001: $-4608 (section "") (file test1.asm:4)
    E Cw $0002 $0003: $ (section "") (file test1.asm:5)
    E Ub $0005 $0006: a2-4608 (section "") (file test1.asm:6)
    E Cw $0007 $0008: a2 (section "") (file test1.asm:7)
    E Cw $000A $000B: a2-a1 (section "") (file test1.asm:8)
    E Cw $000D $000E: $-a1 (section "") (file test1.asm:9)
    E Cw $0010 $0011: a2-$ (section "") (file test1.asm:10)
    E Cw $0013 $0014: __head (section "") (file test1.asm:12)
    E Cw $0016 $0017: __tail (section "") (file test1.asm:13)
    E Cw $0019 $001A: __size (section "") (file test1.asm:14)
END

is_text( scalar(read_file("test.map")), <<'END' );
a1                              = $1247 ; addr, public, , test, , test.asm:13
a2                              = $1263 ; addr, public, , test1, , test1.asm:11
__head                          = $1234 ; const, public, def, , ,
__tail                          = $126C ; const, public, def, , ,
__size                          = $0038 ; const, public, def, , ,
END

#------------------------------------------------------------------------------
# Test sections
my $expected_bin = pack("C*",
					0x21, 0x59, 0x12,
					0x01, 0x05, 0x00,
					0xCD, 0x50, 0x12,
					0x21, 0x5E, 0x12,
					0x01, 0x06, 0x00,
					0xCD, 0x50, 0x12,
					0x21, 0x64, 0x12,
					0x01, 0x01, 0x00,
					0xCD, 0x50, 0x12,
					0xC9,
					0x78,
					0xB1,
					0xC8,
					0x7E,
					0x23,
					0xD7,
					0x0B,
					0x18, 0xF7).
				"hello".
				" world".
				".";

z80asm(
	asm =>	<<'ASM',
			org $1234

			extern prmes, mes0, mes0end

			section code
start:		ld hl,mes1
			ld bc,mes1end - mes1

			section data
mes1:		defm "hello"
mes1end:
			section code
			call prmes

			section code
			ld hl,mes2
			ld bc,mes2end - mes2

			section data
mes2:		defm " world"
mes2end:
			section code
			call prmes

			ld hl,mes0
			ld bc,mes0end - mes0
			call prmes

			section code
			ret
ASM
	asm1 => <<'ASM1',

			section data
mes0:		defm "."
mes0end:

			section code
prmes:		ld 	a, b
			or 	c
			ret z

			ld 	a, (hl)
			inc	hl

			rst $10

			dec	bc
			jr 	prmes

			; declare public in a different section
			section data
			public prmes

			section code
			public mes0, mes0end

ASM1
	options => "-b -l",
	bin		=> $expected_bin,
);

# link only
z80asm(
	options => "-d -b -m test.o test1.o",
	bin		=> $expected_bin,
);

z80nm("test.o test1.o", <<'END');
Object  file test.o at $0000: Z80RMF16
  Name: test
  Section "": 0 bytes, ORG $1234
  Section code: 28 bytes
    C $0000: 21 00 00 01 00 00 CD 00 00 21 00 00 01 00 00 CD
    C $0010: 00 00 21 00 00 01 00 00 CD 00 00 C9
  Section data: 11 bytes
    C $0000: 68 65 6C 6C 6F 20 77 6F 72 6C 64
  Symbols:
    L A $0000 mes1 (section data) (file test.asm:10)
    L A $0000 start (section code) (file test.asm:6)
    L A $0005 mes1end (section data) (file test.asm:11)
    L A $0005 mes2 (section data) (file test.asm:20)
    L A $000B mes2end (section data) (file test.asm:21)
  Externs:
    U         prmes
    U         mes0
    U         mes0end
  Expressions:
    E Cw $0000 $0001: mes1 (section code) (file test.asm:6)
    E Cw $0003 $0004: mes1end-mes1 (section code) (file test.asm:7)
    E Cw $0006 $0007: prmes (section code) (file test.asm:13)
    E Cw $0009 $000A: mes2 (section code) (file test.asm:16)
    E Cw $000C $000D: mes2end-mes2 (section code) (file test.asm:17)
    E Cw $000F $0010: prmes (section code) (file test.asm:23)
    E Cw $0012 $0013: mes0 (section code) (file test.asm:25)
    E Cw $0015 $0016: mes0end-mes0 (section code) (file test.asm:26)
    E Cw $0018 $0019: prmes (section code) (file test.asm:27)
Object  file test1.o at $0000: Z80RMF16
  Name: test1
  Section "": 0 bytes, ORG $1234
  Section code: 9 bytes
    C $0000: 78 B1 C8 7E 23 D7 0B 18 F7
  Section data: 1 bytes
    C $0000: 2E
  Symbols:
    G A $0000 prmes (section code) (file test1.asm:7)
    G A $0000 mes0 (section data) (file test1.asm:3)
    G A $0001 mes0end (section data) (file test1.asm:4)
END

is_text( scalar(read_file("test.map")), <<'END' );
mes1                            = $1259 ; addr, local, , test, data, test.asm:10
start                           = $1234 ; addr, local, , test, code, test.asm:6
mes1end                         = $125E ; addr, local, , test, data, test.asm:11
mes2                            = $125E ; addr, local, , test, data, test.asm:20
mes2end                         = $1264 ; addr, local, , test, data, test.asm:21
prmes                           = $1250 ; addr, public, , test1, code, test1.asm:7
mes0                            = $1264 ; addr, public, , test1, data, test1.asm:3
mes0end                         = $1265 ; addr, public, , test1, data, test1.asm:4
__head                          = $1234 ; const, public, def, , ,
__tail                          = $1265 ; const, public, def, , ,
__size                          = $0031 ; const, public, def, , ,
__code_head                     = $1234 ; const, public, def, , ,
__code_tail                     = $1259 ; const, public, def, , ,
__code_size                     = $0025 ; const, public, def, , ,
__data_head                     = $1259 ; const, public, def, , ,
__data_tail                     = $1265 ; const, public, def, , ,
__data_size                     = $000C ; const, public, def, , ,
END

#------------------------------------------------------------------------------
# Test empty sections
z80asm(
	asm 	=> <<'ASM',
		section code
		section data
		section bss

		section bss
		defb 3
ASM
	asm1 	=> <<'ASM1',
		section code
		section data
		section bss

		section data
		defb 2
ASM1
	asm2 	=> <<'ASM2',
		section code
		section data
		section bss

		section code
		defb 1
ASM2
	bin		=> "\1\2\3",
);
z80nm("test.o test1.o test2.o", <<'END');
Object  file test.o at $0000: Z80RMF16
  Name: test
  Section code: 0 bytes
  Section data: 0 bytes
  Section bss: 1 bytes
    C $0000: 03
Object  file test1.o at $0000: Z80RMF16
  Name: test1
  Section code: 0 bytes
  Section data: 1 bytes
    C $0000: 02
  Section bss: 0 bytes
Object  file test2.o at $0000: Z80RMF16
  Name: test2
  Section code: 1 bytes
    C $0000: 01
  Section data: 0 bytes
  Section bss: 0 bytes
END

# link only
z80asm(
	options => "-d -b test.o test1.o test2.o",
	bin		=> "\1\2\3",
);
z80nm("test.o test1.o test2.o", <<'END');
Object  file test.o at $0000: Z80RMF16
  Name: test
  Section code: 0 bytes
  Section data: 0 bytes
  Section bss: 1 bytes
    C $0000: 03
Object  file test1.o at $0000: Z80RMF16
  Name: test1
  Section code: 0 bytes
  Section data: 1 bytes
    C $0000: 02
  Section bss: 0 bytes
Object  file test2.o at $0000: Z80RMF16
  Name: test2
  Section code: 1 bytes
    C $0000: 01
  Section data: 0 bytes
  Section bss: 0 bytes
END

#------------------------------------------------------------------------------
# Test computed DEFC 1
$expected_bin = pack("v*", 0x100, 0x108, 0x108, 0x108);
z80asm(
	asm		=> <<'...',
			org 0x100
		start:
			defw start,end1,end2,end3
		end1:
			defc end2 = asmpc
			defc end3 = end1
...
	options => "-b",
	bin		=> $expected_bin,
);

# link only
z80asm(
	options => "-d -b test.o",
	bin		=> $expected_bin,
);

z80nm("test.o", <<'...');
Object  file test.o at $0000: Z80RMF16
  Name: test
  Section "": 8 bytes, ORG $0100
    C $0000: 00 00 00 00 00 00 00 00
  Symbols:
    L A $0000 start (section "") (file test.asm:2)
    L A $0008 end1 (section "") (file test.asm:4)
    L A $0008 end2 (section "") (file test.asm:5)
    L A $0008 end3 (section "") (file test.asm:6)
  Expressions:
    E Cw $0000 $0000: start (section "") (file test.asm:3)
    E Cw $0000 $0002: end1 (section "") (file test.asm:3)
    E Cw $0000 $0004: end2 (section "") (file test.asm:3)
    E Cw $0000 $0006: end3 (section "") (file test.asm:3)
...

#------------------------------------------------------------------------------
# Test computed DEFC 2
$expected_bin = pack("C*",
					# section code		# @ 0x1000
					0xCD, 0x0A, 0x10,	# @ 0x1000 : main
					0xCD, 0x09, 0x10,	# @ 0x1003
					0xC3, 0x0B, 0x10,	# @ 0x1006
					0xC8,				# @ 0x1009 : func2
					# section lib		# @ 0x100A
					0xC9,				# @ 0x100A : func1
										# @ 0x100B : computed_end
				);
z80asm(
	asm		=> <<'ASM',
		section code
		section lib

		extern func1_alias, func2_alias, computed_end

		section code
		call func1_alias
		call func2_alias
		jp   computed_end
ASM
	asm1	=> <<'ASM1',
		section code
		section lib

		public func1, func2

		section lib
func1:	ret

		section code
func2:	ret z

ASM1
	asm2	=> <<'ASM2',
		section code
		section lib

		extern func1, func2
		public func1_alias, func2_alias, computed_end

		defc func1_alias = func1		; link lib to lib
		defc func2_alias = func2		; link lib to code

		defc computed_end = chain1 + 1
		defc chain1 = chain2 - 1
		defc chain2 = ASMPC
ASM2
	options => "-r0x1000 -b",
	bin		=> $expected_bin,
);

# link only
z80asm(
	options => "-d -b test.o test1.o test2.o",
	bin		=> $expected_bin,
);

z80nm("test.o test1.o test2.o", <<'END');
Object  file test.o at $0000: Z80RMF16
  Name: test
  Section "": 0 bytes, ORG $1000
  Section code: 9 bytes
    C $0000: CD 00 00 CD 00 00 C3 00 00
  Section lib: 0 bytes
  Externs:
    U         func1_alias
    U         func2_alias
    U         computed_end
  Expressions:
    E Cw $0000 $0001: func1_alias (section code) (file test.asm:7)
    E Cw $0003 $0004: func2_alias (section code) (file test.asm:8)
    E Cw $0006 $0007: computed_end (section code) (file test.asm:9)
Object  file test1.o at $0000: Z80RMF16
  Name: test1
  Section "": 0 bytes, ORG $1000
  Section code: 1 bytes
    C $0000: C8
  Section lib: 1 bytes
    C $0000: C9
  Symbols:
    G A $0000 func1 (section lib) (file test1.asm:7)
    G A $0000 func2 (section code) (file test1.asm:10)
Object  file test2.o at $0000: Z80RMF16
  Name: test2
  Section "": 0 bytes, ORG $1000
  Section code: 0 bytes
  Section lib: 0 bytes
  Symbols:
    L = $0000 chain1 (section lib) (file test2.asm:11)
    L A $0000 chain2 (section lib) (file test2.asm:12)
    G = $0000 func1_alias (section lib) (file test2.asm:7)
    G = $0000 func2_alias (section lib) (file test2.asm:8)
    G = $0000 computed_end (section lib) (file test2.asm:10)
  Externs:
    U         func1
    U         func2
  Expressions:
    E =  $0000 $0000: func1_alias := func1 (section lib) (file test2.asm:7)
    E =  $0000 $0000: func2_alias := func2 (section lib) (file test2.asm:8)
    E =  $0000 $0000: computed_end := chain1+1 (section lib) (file test2.asm:10)
    E =  $0000 $0000: chain1 := chain2-1 (section lib) (file test2.asm:11)
END

#------------------------------------------------------------------------------
# Use before external declaration
$expected_bin = pack("C*",
					0xCD, 0x04, 0x10,	# @ 0x1000 : func1
					0xC9,				# @ 0x1003
					0xCD, 0x00, 0x10,	# @ 0x1004 : func2
					0xC9,				# @ 0x1007
				);

# declare before define
z80asm(
	asm		=> <<'ASM',
			PUBLIC func1
			EXTERN func2
	func1:	call func2
			ret
ASM
	asm1	=> <<'ASM1',
			PUBLIC func2
			EXTERN func1
	func2:	call func1
			ret
ASM1
	options => "-r0x1000 -b",
	bin		=> $expected_bin,
);

# define before declare
z80asm(
	asm		=> <<'ASM',
	func1:	call func2
			ret
			PUBLIC func1
			EXTERN func2
ASM
	asm1	=> <<'ASM1',
	func2:	call func1
			ret
			PUBLIC func2
			EXTERN func1
ASM1
	options => "-r0x1000 -b",
	bin		=> $expected_bin,
);

# link only
z80asm(
	options => "-d -b test.o test1.o test2.o",
	bin		=> $expected_bin,
);

z80nm("test.o test1.o", <<'END');
Object  file test.o at $0000: Z80RMF16
  Name: test
  Section "": 4 bytes, ORG $1000
    C $0000: CD 00 00 C9
  Symbols:
    G A $0000 func1 (section "") (file test.asm:1)
  Externs:
    U         func2
  Expressions:
    E Cw $0000 $0001: func2 (section "") (file test.asm:1)
Object  file test1.o at $0000: Z80RMF16
  Name: test1
  Section "": 4 bytes, ORG $1000
    C $0000: CD 00 00 C9
  Symbols:
    G A $0000 func2 (section "") (file test1.asm:1)
  Externs:
    U         func1
  Expressions:
    E Cw $0000 $0001: func1 (section "") (file test1.asm:1)
END

#------------------------------------------------------------------------------
# Declare label as public, use it in an expression and dont define it - crash
write_file("test.asm", <<'END');
				PUBLIC	sd_write_block_2gb
				EXTERN	ASMDISP_SD_WRITE_BLOCK_2GB_CALLEE

			sd_write_sector:
				jp sd_write_block_2gb + ASMDISP_SD_WRITE_BLOCK_2GB_CALLEE ;; error: undefined symbol: sd_write_block_2gb
END
my($stdout, $stderr, $return, @dummy) = capture { system "./z88dk-z80asm test.asm"; };
is_text( $stdout, "" );
is_text( $stderr, <<'END' );
test.asm:5: error: undefined symbol: sd_write_block_2gb
  ^---- sd_write_block_2gb+ASMDISP_SD_WRITE_BLOCK_2GB_CALLEE
test.asm:1: error: undefined symbol: sd_write_block_2gb
END
is !!$return, !!1;

#------------------------------------------------------------------------------
# DEFC use case for library entry points
z80asm(
	asm		=> <<'...',
				PUBLIC asm_b_vector_at
				EXTERN asm_b_array_at

				DEFC asm_b_vector_at = asm_b_array_at
...
	asm1	=> <<'...',
				PUBLIC asm_b_array_at

			asm_b_array_at:				; 1000
				ret						; 1000 ;; C9
										; 1001
...
	asm2	=> <<'...',
				EXTERN asm_b_vector_at
				EXTERN asm_b_array_at

			start:						; 1001
				call asm_b_vector_at	; 1001 ;; CD 00 10
				call asm_b_array_at		; 1004 ;; CD 00 10
				ret						; 1007 ;; C9
...
	options => "-r0x1000 -b",
);

# link only
$expected_bin = read_binfile("test.bin");
z80asm(
	options => "-d -b test.o test1.o test2.o",
	bin		=> $expected_bin,
);

z80nm("test.o test1.o test2.o", <<'...');
Object  file test.o at $0000: Z80RMF16
  Name: test
  Section "": 0 bytes, ORG $1000
  Symbols:
    G = $0000 asm_b_vector_at (section "") (file test.asm:4)
  Externs:
    U         asm_b_array_at
  Expressions:
    E =  $0000 $0000: asm_b_vector_at := asm_b_array_at (section "") (file test.asm:4)
Object  file test1.o at $0000: Z80RMF16
  Name: test1
  Section "": 1 bytes, ORG $1000
    C $0000: C9
  Symbols:
    G A $0000 asm_b_array_at (section "") (file test1.asm:3)
Object  file test2.o at $0000: Z80RMF16
  Name: test2
  Section "": 7 bytes, ORG $1000
    C $0000: CD 00 00 CD 00 00 C9
  Symbols:
    L A $0000 start (section "") (file test2.asm:4)
  Externs:
    U         asm_b_vector_at
    U         asm_b_array_at
  Expressions:
    E Cw $0000 $0001: asm_b_vector_at (section "") (file test2.asm:5)
    E Cw $0003 $0004: asm_b_array_at (section "") (file test2.asm:6)
...

#------------------------------------------------------------------------------
# Test output binary files for a banked system
write_file("test.asm", <<'...');

		section bank0
		org 0
		public  start0, bank_switch_0, func0

	start0:
		ret

		defs 8 - ASMPC

	bank_switch_0:
		ret

	func0:
		ret
...
write_file("test1.asm", <<'...');

		section bank1
		org 0
		public  start1, bank_switch_1, func1
		extern  start0, func0

	start1:
		call bank_switch_1
		defw start0

		defs 8 - ASMPC

	bank_switch_1:
		ret

		nop

	func1:
		ret
...
write_file("test2.asm", <<'...');

		section main
		org $4000
		extern  bank_switch_0, func0, bank_switch_1, func1

	main:
		call bank_switch_0
		defw func0
		call bank_switch_1
		defw func1
		ret
...
my $cmd = "./z88dk-z80asm -b test.asm test1.asm test2.asm";
ok 1, $cmd;
($stdout, $stderr, $return, @dummy) = capture { system $cmd; };
is_text( $stdout, "", "stdout" );
is_text( $stderr, "", "stderr" );
ok !!$return == !!0, "retval";
ok ! -f "test.bin", "test.bin";
is read_binfile("test_bank0.bin"), "\xC9\0\0\0\0\0\0\0\xC9\xC9", "test_bank0.bin";
is read_binfile("test_bank1.bin"), "\xCD\x08\x00\x00\x00\0\0\0\xC9\x00\xC9", "test_bank1.bin";
is read_binfile("test_main.bin"), "\xCD\x08\x00\x09\x00\xCD\x08\x00\x0A\x00\xC9", "test_main.bin";

#------------------------------------------------------------------------------
# Test consolidated object file
write_file("test1.asm", <<'...');
		global main, main1, print, lib_start, lib_end

		section code
	main:
		call lib_start
		ld hl,mess
		call print
		call lib_end
		ret

		section data
	mess: defb "hello "

		defc main1 = main
...

write_file("test2.asm", <<'...');
		global print, print1, printa

		defc print = print1
		defc printa1 = printa

		section code
	printa:
		ld a,(hl)
		and a
		ret z
		rst 10h
		inc hl
		call _delay
		jp printa1

	_delay:
		ld b,0
	_delay_1:
		dec b
		jp nz, _delay_1
		ret

		section data
	mess: defb "world"
...

write_file("test3.asm", <<'...');
		global print1, printa

		section code
	print1:
		push hl
		call printa
		pop hl
		ret

		section data
	mess: defb "!", 0
	dollar:	defw ASMPC
...

write_file("test4.asm", <<'...');
		global code_end

		section code
	code_end:
...

write_file("test_lib.asm", <<'...');
		global lib_start, lib_end

		defc lib_start = 0
		defc lib_end   = 0
...

my $bincode = sub {
	my($addr) = @_;
	my $code;
	my $data;
	my $l_main = 0;
	my $l_print = 0;
	my $l_print1 = 0;
	my $l_printa = 0;
	my $l_mess = 0;
	my $l_dollar = 0;
	my $l_delay = 0;
	my $l_delay1 = 0;

	for my $pass (1..2) {
		$code = "";
		$data = "";

		# test1.asm
		$l_main = $addr + length($code);
		$code .= pack("Cv", 0xCD, 0).
				 pack("Cv", 0x21, $l_mess).
				 pack("Cv", 0xCD, $l_print).
				 pack("Cv", 0xCD, 0).
				 pack("C",  0xC9);

		$data .= "hello ";

		# test2.asm
		$l_printa = $addr + length($code);
		$code .= pack("C*",	0x7E,
							0xA7,
							0xC8,
							0xD7,
							0x23).
				 pack("Cv",	0xCD, $l_delay).
				 pack("Cv",	0xC3, $l_printa);

		$l_delay = $addr + length($code);
		$code .= pack("C*",	0x06, 0x00);

		$l_delay1 = $addr + length($code);
		$code .= pack("C*",	0x05).
				 pack("Cv",	0xC2, $l_delay1).
				 pack("C*",	0xC9);

		$data .= "world";

		# test3.asm
		$l_print1 = $addr + length($code);
		$code .= pack("C*",	0xE5).
				 pack("Cv",	0xCD, $l_printa).
				 pack("C*",	0xE1,
							0xC9);

		$data .= "!\0";
		$data .= pack("v", $l_dollar);

		if ($pass == 1) {
			$l_mess = $addr + length($code);
			$l_dollar = $addr + length($code) + length($data) - 2;
			$l_print = $l_print1;
		}
	}

	my $bin = $code.$data;
	return $bin;
};

$cmd = "./z88dk-z80asm -s -otest.o test1.asm test2.asm test3.asm test4.asm";
ok 1, $cmd;
($stdout, $stderr, $return, @dummy) = capture { system $cmd; };
is_text( $stdout, "", "stdout" );
is_text( $stderr, "", "stderr" );
ok !!$return == !!0, "retval";

z80nm("test.o", <<'END');
Object  file test.o at $0000: Z80RMF16
  Name: test
  Section code: 37 bytes
    C $0000: CD 00 00 21 00 00 CD 00 00 CD 00 00 C9 7E A7 C8
    C $0010: D7 23 CD 00 00 C3 00 00 06 00 05 C2 00 00 C9 E5
    C $0020: CD 00 00 E1 C9
  Section data: 15 bytes
    C $0000: 68 65 6C 6C 6F 20 77 6F 72 6C 64 21 00 00 00
  Symbols:
    L A $0000 test1_mess (section data) (file test1.asm:12)
    L = $0000 test2_printa1 (section "") (file test2.asm:4)
    L A $0018 test2__delay (section code) (file test2.asm:16)
    L A $001A test2__delay_1 (section code) (file test2.asm:18)
    L A $0006 test2_mess (section data) (file test2.asm:24)
    L A $000B test3_mess (section data) (file test3.asm:11)
    L A $000D test3_dollar (section data) (file test3.asm:12)
    G A $0000 main (section code) (file test1.asm:4)
    G = $0000 main1 (section data) (file test1.asm:14)
    G = $0000 print (section "") (file test2.asm:3)
    G A $000D printa (section code) (file test2.asm:7)
    G A $001F print1 (section code) (file test3.asm:4)
    G A $0025 code_end (section code) (file test4.asm:4)
  Externs:
    U         lib_start
    U         lib_end
  Expressions:
    E Cw $0000 $0001: lib_start (section code) (file test1.asm:5)
    E Cw $0003 $0004: test1_mess (section code) (file test1.asm:6)
    E Cw $0006 $0007: print (section code) (file test1.asm:7)
    E Cw $0009 $000A: lib_end (section code) (file test1.asm:8)
    E =  $0006 $0006: main1 := main (section data) (file test1.asm:14)
    E Cw $001B $001C: test2__delay_1 (section code) (file test2.asm:20)
    E Cw $0015 $0016: test2_printa1 (section code) (file test2.asm:14)
    E Cw $0012 $0013: test2__delay (section code) (file test2.asm:13)
    E =  $0000 $0000: test2_printa1 := printa (section "") (file test2.asm:4)
    E =  $0000 $0000: print := print1 (section "") (file test2.asm:3)
    E Cw $000D $000D: $ (section data) (file test3.asm:12)
    E Cw $0020 $0021: printa (section code) (file test3.asm:6)
END

is_text( scalar(read_file("test.sym")), <<'END' );
test1_mess                      = $0000 ; addr, local, , , data, test1.asm:12
test2_printa1                   = $0000 ; comput, local, , , , test2.asm:4
test2__delay                    = $0018 ; addr, local, , , code, test2.asm:16
test2__delay_1                  = $001A ; addr, local, , , code, test2.asm:18
test2_mess                      = $0006 ; addr, local, , , data, test2.asm:24
test3_mess                      = $000B ; addr, local, , , data, test3.asm:11
test3_dollar                    = $000D ; addr, local, , , data, test3.asm:12
main                            = $0000 ; addr, public, , , code, test1.asm:4
main1                           = $0000 ; comput, public, , , data, test1.asm:14
print                           = $0000 ; comput, public, , , , test2.asm:3
printa                          = $000D ; addr, public, , , code, test2.asm:7
print1                          = $001F ; addr, public, , , code, test3.asm:4
code_end                        = $0025 ; addr, public, , , code, test4.asm:4
END

# at address 0
unlink "test.asm", "test.bin";

$cmd = "./z88dk-z80asm -b -m test.o test_lib.asm";
ok 1, $cmd;
($stdout, $stderr, $return, @dummy) = capture { system $cmd; };
is_text( $stdout, "", "stdout" );
is_text( $stderr, "", "stderr" );
ok !!$return == !!0, "retval";
test_binfile("test.bin", $bincode->(0));

is_text( scalar(read_file("test.map")), <<'END' );
test1_mess                      = $0025 ; addr, local, , test, data, test1.asm:12
test2_printa1                   = $000D ; addr, local, , test, , test2.asm:4
test2__delay                    = $0018 ; addr, local, , test, code, test2.asm:16
test2__delay_1                  = $001A ; addr, local, , test, code, test2.asm:18
test2_mess                      = $002B ; addr, local, , test, data, test2.asm:24
test3_mess                      = $0030 ; addr, local, , test, data, test3.asm:11
test3_dollar                    = $0032 ; addr, local, , test, data, test3.asm:12
main                            = $0000 ; addr, public, , test, code, test1.asm:4
main1                           = $0000 ; addr, public, , test, data, test1.asm:14
print                           = $001F ; addr, public, , test, , test2.asm:3
printa                          = $000D ; addr, public, , test, code, test2.asm:7
print1                          = $001F ; addr, public, , test, code, test3.asm:4
code_end                        = $0025 ; addr, public, , test, code, test4.asm:4
lib_start                       = $0000 ; const, public, , test_lib, , test_lib.asm:3
lib_end                         = $0000 ; const, public, , test_lib, , test_lib.asm:4
__head                          = $0000 ; const, public, def, , ,
__tail                          = $0034 ; const, public, def, , ,
__size                          = $0034 ; const, public, def, , ,
__code_head                     = $0000 ; const, public, def, , ,
__code_tail                     = $0025 ; const, public, def, , ,
__code_size                     = $0025 ; const, public, def, , ,
__data_head                     = $0025 ; const, public, def, , ,
__data_tail                     = $0034 ; const, public, def, , ,
__data_size                     = $000F ; const, public, def, , ,
END

# at address 0x1234
unlink "test.asm", "test.bin";

$cmd = "./z88dk-z80asm -b -m -r0x1234 test.o test_lib.asm";
ok 1, $cmd;
($stdout, $stderr, $return, @dummy) = capture { system $cmd; };
is_text( $stdout, "", "stdout" );
is_text( $stderr, "", "stderr" );
ok !!$return == !!0, "retval";
test_binfile("test.bin", $bincode->(0x1234));

is_text( scalar(read_file("test.map")), <<'END' );
test1_mess                      = $1259 ; addr, local, , test, data, test1.asm:12
test2_printa1                   = $1241 ; addr, local, , test, , test2.asm:4
test2__delay                    = $124C ; addr, local, , test, code, test2.asm:16
test2__delay_1                  = $124E ; addr, local, , test, code, test2.asm:18
test2_mess                      = $125F ; addr, local, , test, data, test2.asm:24
test3_mess                      = $1264 ; addr, local, , test, data, test3.asm:11
test3_dollar                    = $1266 ; addr, local, , test, data, test3.asm:12
main                            = $1234 ; addr, public, , test, code, test1.asm:4
main1                           = $1234 ; addr, public, , test, data, test1.asm:14
print                           = $1253 ; addr, public, , test, , test2.asm:3
printa                          = $1241 ; addr, public, , test, code, test2.asm:7
print1                          = $1253 ; addr, public, , test, code, test3.asm:4
code_end                        = $1259 ; addr, public, , test, code, test4.asm:4
lib_start                       = $0000 ; const, public, , test_lib, , test_lib.asm:3
lib_end                         = $0000 ; const, public, , test_lib, , test_lib.asm:4
__head                          = $1234 ; const, public, def, , ,
__tail                          = $1268 ; const, public, def, , ,
__size                          = $0034 ; const, public, def, , ,
__code_head                     = $1234 ; const, public, def, , ,
__code_tail                     = $1259 ; const, public, def, , ,
__code_size                     = $0025 ; const, public, def, , ,
__data_head                     = $1259 ; const, public, def, , ,
__data_tail                     = $1268 ; const, public, def, , ,
__data_size                     = $000F ; const, public, def, , ,
END

#------------------------------------------------------------------------------
# Test library with specialized and generalized version of same function
write_file("test_gen.asm", <<'...');
		global putpixel

	putpixel:
		ld a, 1
		ret
...


# platform 1 uses the generic putpixel
write_file("test_plat1.asm", <<'...');
...

$cmd = "./z88dk-z80asm -xtest_plat1.lib test_plat1 test_gen";
ok 1, $cmd;
($stdout, $stderr, $return, @dummy) = capture { system $cmd; };
is_text( $stdout, "", "stdout" );
is_text( $stderr, "", "stderr" );
ok !!$return == !!0, "retval";


# platform 2 uses a specific putpixel
write_file("test_plat2.asm", <<'...');
		global putpixel

	putpixel:
		ld a, 2
		ret
...

$cmd = "./z88dk-z80asm -xtest_plat2.lib test_plat2 test_gen";
ok 1, $cmd;
($stdout, $stderr, $return, @dummy) = capture { system $cmd; };
is_text( $stdout, "", "stdout" );
is_text( $stderr, "", "stderr" );
ok !!$return == !!0, "retval";


# generic source
write_file("test.asm", <<'...');
		global putpixel
		jp putpixel
...


# link on platform 1
$cmd = "./z88dk-z80asm -ltest_plat1.lib -b test";
ok 1, $cmd;
($stdout, $stderr, $return, @dummy) = capture { system $cmd; };
is_text( $stdout, "", "stdout" );
is_text( $stderr, "", "stderr" );
ok !!$return == !!0, "retval";
test_binfile("test.bin", pack("C*", 0xC3, 3, 0, 0x3E, 1, 0xC9));


# link on platform 2
$cmd = "./z88dk-z80asm -ltest_plat2.lib -b test";
ok 1, $cmd;
($stdout, $stderr, $return, @dummy) = capture { system $cmd; };
is_text( $stdout, "", "stdout" );
is_text( $stderr, "", "stderr" );
ok !!$return == !!0, "retval";
test_binfile("test.bin", pack("C*", 0xC3, 3, 0, 0x3E, 2, 0xC9));

z80nm("test_plat1.lib", <<'END');
Library file test_plat1.lib at $0000: Z80LMF16
Object  file test_plat1.lib at $0010: Z80RMF16
  Name: test_plat1

Object  file test_plat1.lib at $0040: Z80RMF16
  Name: test_gen
  Section "": 3 bytes
    C $0000: 3E 01 C9
  Symbols:
    G A $0000 putpixel (section "") (file test_gen.asm:3)

END


z80nm("test_plat2.lib", <<'END');
Library file test_plat2.lib at $0000: Z80LMF16
Object  file test_plat2.lib at $0010: Z80RMF16
  Name: test_plat2
  Section "": 3 bytes
    C $0000: 3E 02 C9
  Symbols:
    G A $0000 putpixel (section "") (file test_plat2.asm:3)

Object  file test_plat2.lib at $007C: Z80RMF16
  Name: test_gen
  Section "": 3 bytes
    C $0000: 3E 01 C9
  Symbols:
    G A $0000 putpixel (section "") (file test_gen.asm:3)

END

#------------------------------------------------------------------------------
# Bug report: alvin (alvin_albrecht@hotmail.com) <lists@suborbital.org.uk> via lists.sourceforge.net
# date:	Mon, Oct 17, 2016 at 8:11 AM
# For some reason, in pietro_loader.asm, the symbols "__LOADER_head" and "__LOADER_CODE_tail" are
# being made public when a consolidated object is built.  It is only those two symbols despite
# other section symbols being used in the same file.
write_file("test1.asm", <<'...');
	SECTION LOADER
	EXTERN __LOADER_head, __LOADER_tail
	ld hl, __LOADER_tail -__LOADER_head
...

$cmd = "./z88dk-z80asm test1.asm";
ok 1, $cmd;
($stdout, $stderr, $return, @dummy) = capture { system $cmd; };
is_text( $stdout, "", "stdout" );
is_text( $stderr, "", "stderr" );
ok !!$return == !!0, "retval";

$cmd = "../../src/z80nm/z88dk-z80nm test1.o";
ok 1, $cmd;
($stdout, $stderr, $return, @dummy) = capture { system $cmd; };
$stdout = join("\n", grep {/__/} split(/\n/, $stdout))."\n";
is_text( $stdout, <<'END', "stdout" );
    U         __LOADER_head
    U         __LOADER_tail
END
is_text( $stderr, "", "stderr" );
ok !!$return == !!0, "retval";


$cmd = "./z88dk-z80asm -otest1.o test1.asm";
ok 1, $cmd;
($stdout, $stderr, $return, @dummy) = capture { system $cmd; };
is_text( $stdout, "", "stdout" );
is_text( $stderr, "", "stderr" );
ok !!$return == !!0, "retval";

$cmd = "../../src/z80nm/z88dk-z80nm test1.o";
ok 1, $cmd;
($stdout, $stderr, $return, @dummy) = capture { system $cmd; };
$stdout = join("\n", grep {/__/} split(/\n/, $stdout))."\n";
is_text( $stdout, <<'END', "stdout" );
    U         __LOADER_head
    U         __LOADER_tail
END
is_text( $stderr, "", "stderr" );
ok !!$return == !!0, "retval";

