#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2015
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Test linking of modules

use Modern::Perl;
use t::TestZ80asm;

#------------------------------------------------------------------------------
# Test expressions across modules
z80asm(
	asm =>	<<'ASM',
			org $1234
			
			public a1
			extern a2, ASMHEAD, ASMTAIL, ASMSIZE
			
			ld	a, ASMPC -$1200	;$1234 ;; 3E 34
			jp	ASMPC			;$1236 ;; C3 36 12
			ld	b, a1 -$1200	;$1239 ;; 06 47
			jp	a1				;$123B ;; C3 47 12
			ld	hl, a2 - a1		;$123E ;; 21 1C 00
			ld	bc, a1 - ASMPC	;$1241 ;; 01 06 00
			ld	de, a2 - ASMPC	;$1244 ;; 11 1F 00
	a1:							;$1247
			ld	hl, ASMHEAD		;$1247 ;; 21 34 12
			ld	de, ASMTAIL		;$124A ;; 11 6C 12
			ld	bc, ASMSIZE		;$124D ;; 01 38 00
								;$1250
ASM
	asm1 => <<'ASM1',
			public a2
			extern a1, ASMHEAD, ASMTAIL, ASMSIZE
			
			ld	a, ASMPC -$1200	;$1250 ;; 3E 50
			jp	ASMPC			;$1252 ;; C3 52 12
			ld	b, a2 -$1200	;$1255 ;; 06 63
			jp	a2				;$1257 ;; C3 63 12
			ld	hl, a2 - a1		;$125A ;; 21 1C 00
			ld	bc, ASMPC - a1	;$125D ;; 01 16 00
			ld	de, a2 - ASMPC	;$1260 ;; 11 03 00
	a2:							;$1263
			ld	hl, ASMHEAD		;$1263 ;; 21 34 12
			ld	de, ASMTAIL		;$1266 ;; 11 6C 12
			ld	bc, ASMSIZE		;$1269 ;; 01 38 00
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

File test.o at $0000: Z80RMF08
  Name: test
  Names:
    G A $0013 a1
  External names:
    U         a2
    U         ASMHEAD
    U         ASMTAIL
    U         ASMSIZE
  Expressions:
    E Ub (test.asm:6) $0000 $0001: ASMPC-4608
    E Cw (test.asm:7) $0002 $0003: ASMPC
    E Ub (test.asm:8) $0005 $0006: a1-4608
    E Cw (test.asm:9) $0007 $0008: a1
    E Cw (test.asm:10) $000A $000B: a2-a1
    E Cw (test.asm:11) $000D $000E: a1-ASMPC
    E Cw (test.asm:12) $0010 $0011: a2-ASMPC
    E Cw (test.asm:14) $0013 $0014: ASMHEAD
    E Cw (test.asm:15) $0016 $0017: ASMTAIL
    E Cw (test.asm:16) $0019 $001A: ASMSIZE
  Code: 28 bytes, ORG at $1234
    C $0000: 3E 00 C3 00 00 06 00 C3 00 00 21 00 00 01 00 00
    C $0010: 11 00 00 21 00 00 11 00 00 01 00 00

File test1.o at $0000: Z80RMF08
  Name: test1
  Names:
    G A $0013 a2
  External names:
    U         a1
    U         ASMHEAD
    U         ASMTAIL
    U         ASMSIZE
  Expressions:
    E Ub (test1.asm:4) $0000 $0001: ASMPC-4608
    E Cw (test1.asm:5) $0002 $0003: ASMPC
    E Ub (test1.asm:6) $0005 $0006: a2-4608
    E Cw (test1.asm:7) $0007 $0008: a2
    E Cw (test1.asm:8) $000A $000B: a2-a1
    E Cw (test1.asm:9) $000D $000E: ASMPC-a1
    E Cw (test1.asm:10) $0010 $0011: a2-ASMPC
    E Cw (test1.asm:12) $0013 $0014: ASMHEAD
    E Cw (test1.asm:13) $0016 $0017: ASMTAIL
    E Cw (test1.asm:14) $0019 $001A: ASMSIZE
  Code: 28 bytes, ORG at $1234
    C $0000: 3E 00 C3 00 00 06 00 C3 00 00 21 00 00 01 00 00
    C $0010: 11 00 00 21 00 00 11 00 00 01 00 00
END

eq_or_diff scalar(read_file("test.map")), <<'END';
ASMSIZE                         = $0038 ; G 
ASMHEAD                         = $1234 ; G 
a1                              = $1247 ; G test
a2                              = $1263 ; G test1
ASMTAIL                         = $126C ; G 
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

File test.o at $0000: Z80RMF08
  Name: test
  Names:
    L A $0000 mes1 (section data)
    L A $0000 start (section code)
    L A $0005 mes1end (section data)
    L A $0005 mes2 (section data)
    L A $000B mes2end (section data)
  External names:
    U         prmes
    U         mes0
    U         mes0end
  Expressions:
    E Cw (test.asm:6) $0000 $0001: mes1 (section code)
    E Cw (test.asm:7) $0003 $0004: mes1end-mes1 (section code)
    E Cw (test.asm:13) $0006 $0007: prmes (section code)
    E Cw (test.asm:16) $0009 $000A: mes2 (section code)
    E Cw (test.asm:17) $000C $000D: mes2end-mes2 (section code)
    E Cw (test.asm:23) $000F $0010: prmes (section code)
    E Cw (test.asm:25) $0012 $0013: mes0 (section code)
    E Cw (test.asm:26) $0015 $0016: mes0end-mes0 (section code)
    E Cw (test.asm:27) $0018 $0019: prmes (section code)
  Code: 0 bytes, ORG at $1234
  Code: 28 bytes (section code)
    C $0000: 21 00 00 01 00 00 CD 00 00 21 00 00 01 00 00 CD
    C $0010: 00 00 21 00 00 01 00 00 CD 00 00 C9
  Code: 11 bytes (section data)
    C $0000: 68 65 6C 6C 6F 20 77 6F 72 6C 64

File test1.o at $0000: Z80RMF08
  Name: test1
  Names:
    G A $0000 prmes (section code)
    G A $0000 mes0 (section data)
    G A $0001 mes0end (section data)
  Code: 0 bytes, ORG at $1234
  Code: 9 bytes (section code)
    C $0000: 78 B1 C8 7E 23 D7 0B 18 F7
  Code: 1 bytes (section data)
    C $0000: 2E
END

eq_or_diff scalar(read_file("test.map")), <<'END';
ASMSIZE_data                    = $000C ; G 
ASMSIZE_code                    = $0025 ; G 
ASMSIZE                         = $0031 ; G 
ASMHEAD                         = $1234 ; G 
ASMHEAD_code                    = $1234 ; G 
start                           = $1234 ; L test
prmes                           = $1250 ; G test1
ASMHEAD_data                    = $1259 ; G 
ASMTAIL_code                    = $1259 ; G 
mes1                            = $1259 ; L test
mes1end                         = $125E ; L test
mes2                            = $125E ; L test
mes0                            = $1264 ; G test1
mes2end                         = $1264 ; L test
ASMTAIL                         = $1265 ; G 
ASMTAIL_data                    = $1265 ; G 
mes0end                         = $1265 ; G test1
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

File test.o at $0000: Z80RMF08
  Name: test
  Code: 0 bytes (section code)
  Code: 0 bytes (section data)
  Code: 1 bytes (section bss)
    C $0000: 03

File test1.o at $0000: Z80RMF08
  Name: test1
  Code: 0 bytes (section code)
  Code: 1 bytes (section data)
    C $0000: 02
  Code: 0 bytes (section bss)

File test2.o at $0000: Z80RMF08
  Name: test2
  Code: 1 bytes (section code)
    C $0000: 01
  Code: 0 bytes (section data)
  Code: 0 bytes (section bss)
END

# link only
z80asm(
	options => "-d -b test.o test1.o test2.o",
	bin		=> "\1\2\3",
);
z80nm("test.o test1.o test2.o", <<'END');

File test.o at $0000: Z80RMF08
  Name: test
  Code: 0 bytes (section code)
  Code: 0 bytes (section data)
  Code: 1 bytes (section bss)
    C $0000: 03

File test1.o at $0000: Z80RMF08
  Name: test1
  Code: 0 bytes (section code)
  Code: 1 bytes (section data)
    C $0000: 02
  Code: 0 bytes (section bss)

File test2.o at $0000: Z80RMF08
  Name: test2
  Code: 1 bytes (section code)
    C $0000: 01
  Code: 0 bytes (section data)
  Code: 0 bytes (section bss)
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

File test.o at $0000: Z80RMF08
  Name: test
  Names:
    L A $0000 start
    L A $0008 end1
    L A $0008 end2
    L A $0008 end3
  Expressions:
    E Cw (test.asm:3) $0000 $0000: start
    E Cw (test.asm:3) $0000 $0002: end1
    E Cw (test.asm:3) $0000 $0004: end2
    E Cw (test.asm:3) $0000 $0006: end3
  Code: 8 bytes, ORG at $0100
    C $0000: 00 00 00 00 00 00 00 00
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

File test.o at $0000: Z80RMF08
  Name: test
  External names:
    U         func1_alias
    U         func2_alias
    U         computed_end
  Expressions:
    E Cw (test.asm:7) $0000 $0001: func1_alias (section code)
    E Cw (test.asm:8) $0003 $0004: func2_alias (section code)
    E Cw (test.asm:9) $0006 $0007: computed_end (section code)
  Code: 0 bytes, ORG at $1000
  Code: 9 bytes (section code)
    C $0000: CD 00 00 CD 00 00 C3 00 00
  Code: 0 bytes (section lib)

File test1.o at $0000: Z80RMF08
  Name: test1
  Names:
    G A $0000 func1 (section lib)
    G A $0000 func2 (section code)
  Code: 0 bytes, ORG at $1000
  Code: 1 bytes (section code)
    C $0000: C8
  Code: 1 bytes (section lib)
    C $0000: C9

File test2.o at $0000: Z80RMF08
  Name: test2
  Names:
    L A $FFFFFFFF chain1 (section lib)
    L A $0000 chain2 (section lib)
    G = $0000 func1_alias (section lib)
    G = $0000 func2_alias (section lib)
    G A $0000 computed_end (section lib)
  External names:
    U         func1
    U         func2
  Expressions:
    E =  (test2.asm:7) $0000 $0000: func1_alias := func1 (section lib)
    E =  (test2.asm:8) $0000 $0000: func2_alias := func2 (section lib)
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

File test.o at $0000: Z80RMF08
  Name: test
  Names:
    G A $0000 func1
  External names:
    U         func2
  Expressions:
    E Cw (test.asm:1) $0000 $0001: func2
  Code: 4 bytes, ORG at $1000
    C $0000: CD 00 00 C9

File test1.o at $0000: Z80RMF08
  Name: test1
  Names:
    G A $0000 func2
  External names:
    U         func1
  Expressions:
    E Cw (test1.asm:1) $0000 $0001: func1
  Code: 4 bytes, ORG at $1000
    C $0000: CD 00 00 C9
END

#------------------------------------------------------------------------------
# Declare label as public, use it in an expression and dont define it - crash
z80asm(
	asm		=> <<'...',
				PUBLIC	sd_write_block_2gb
				EXTERN	ASMDISP_SD_WRITE_BLOCK_2GB_CALLEE

			sd_write_sector:
				jp sd_write_block_2gb + ASMDISP_SD_WRITE_BLOCK_2GB_CALLEE ;; error: symbol 'sd_write_block_2gb' not defined
...
	options	=> " ",
);

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

File test.o at $0000: Z80RMF08
  Name: test
  Names:
    G = $0000 asm_b_vector_at
  External names:
    U         asm_b_array_at
  Expressions:
    E =  (test.asm:4) $0000 $0000: asm_b_vector_at := asm_b_array_at

File test1.o at $0000: Z80RMF08
  Name: test1
  Names:
    G A $0000 asm_b_array_at
  Code: 1 bytes, ORG at $1000
    C $0000: C9

File test2.o at $0000: Z80RMF08
  Name: test2
  Names:
    L A $0000 start
  External names:
    U         asm_b_vector_at
    U         asm_b_array_at
  Expressions:
    E Cw (test2.asm:5) $0000 $0001: asm_b_vector_at
    E Cw (test2.asm:6) $0003 $0004: asm_b_array_at
  Code: 7 bytes, ORG at $1000
    C $0000: CD 00 00 CD 00 00 C9
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
my $cmd = "./z80asm -b test.asm test1.asm test2.asm";
ok 1, $cmd;
my($stdout, $stderr, $return) = capture { system $cmd; };
eq_or_diff_text $stdout, "", "stdout";
eq_or_diff_text $stderr, "", "stderr";
ok !!$return == !!0, "retval";
is read_binfile("test.bin"), "", "test.bin";
is read_binfile("test_bank0.bin"), "\xC9\0\0\0\0\0\0\0\xC9\xC9", "test_bank0.bin";
is read_binfile("test_bank1.bin"), "\xCD\x08\x00\x00\x00\0\0\0\xC9\x00\xC9", "test_bank1.bin";
is read_binfile("test_main.bin"), "\xCD\x08\x00\x09\x00\xCD\x08\x00\x0A\x00\xC9", "test_main.bin";

#------------------------------------------------------------------------------
# Test consolidated object file
write_file("test1.asm", <<'...');
		global main, print

		section code
	main:
		ld hl,mess+main-main		; force main to appear in .o file
		call print
		ret
		
		section data
	mess: defb "hello "	
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
		jp printa1
		
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
	
	for my $pass (1..2) {
		$code = "";
		$data = "";
		
		# test1.asm
		$l_main = $addr + length($code);
		$code .= pack("Cv", 0x21, $l_mess).
				 pack("Cv", 0xCD, $l_print).
				 pack("C",  0xC9);
				 
		$data .= "hello ";
		
		# test2.asm
		$l_printa = $addr + length($code);
		$code .= pack("C*",	0x7E,
							0xA7,
							0xC8,
							0xD7,
							0x23).
				 pack("Cv",	0xC3, $l_printa);
		
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

$cmd = "./z80asm -s -otest.o test1.asm test2.asm test3.asm test4.asm";
ok 1, $cmd;
($stdout, $stderr, $return) = capture { system $cmd; };
eq_or_diff_text $stdout, "", "stdout";
eq_or_diff_text $stderr, "", "stderr";
ok !!$return == !!0, "retval";

z80nm("test.o", <<'END');

File test.o at $0000: Z80RMF08
  Name: test
  Names:
    L A $0000 test1_mess (section data)
    L = $0000 test2_printa1
    L A $0006 test2_mess (section data)
    L A $000B test3_mess (section data)
    L A $000D test3_dollar (section data)
    G A $0000 main (section code)
    G = $0000 print
    G A $0007 printa (section code)
    G A $000F print1 (section code)
    G A $0015 code_end (section code)
  Expressions:
    E Cw (test1.asm:5) $0000 $0001: test1_mess+main-main (section code)
    E Cw (test1.asm:6) $0003 $0004: print (section code)
    E Cw (test2.asm:13) $000C $000D: test2_printa1 (section code)
    E =  (test2.asm:4) $0000 $0000: test2_printa1 := printa
    E =  (test2.asm:3) $0000 $0000: print := print1
    E Cw (test3.asm:12) $000D $000D: ASMPC (section data)
    E Cw (test3.asm:6) $0010 $0011: printa (section code)
  Code: 21 bytes (section code)
    C $0000: 21 00 00 CD 00 00 C9 7E A7 C8 D7 23 C3 00 00 E5
    C $0010: CD 00 00 E1 C9
  Code: 15 bytes (section data)
    C $0000: 68 65 6C 6C 6F 20 77 6F 72 6C 64 21 00 00 00
END

eq_or_diff_text norm_nl(scalar(read_file("test.sym"))), norm_nl(<<'END');
main                            = $0000 ; G 
print                           = $0000 ; G 
test1_mess                      = $0000 ; L 
test2_printa1                   = $0000 ; L 
test2_mess                      = $0006 ; L 
printa                          = $0007 ; G 
test3_mess                      = $000B ; L 
test3_dollar                    = $000D ; L 
print1                          = $000F ; G 
code_end                        = $0015 ; G 
END

# at address 0
unlink "test.asm", "test.bin";

$cmd = "./z80asm -b -m test.o";
ok 1, $cmd;
($stdout, $stderr, $return) = capture { system $cmd; };
eq_or_diff_text $stdout, "", "stdout";
eq_or_diff_text $stderr, "", "stderr";
ok !!$return == !!0, "retval";
test_binfile("test.bin", $bincode->(0));

eq_or_diff_text norm_nl(scalar(read_file("test.map"))), norm_nl(<<'END');
ASMHEAD                         = $0000 ; G 
ASMHEAD_code                    = $0000 ; G 
main                            = $0000 ; G test
printa                          = $0007 ; G test
test2_printa1                   = $0007 ; L test
ASMSIZE_data                    = $000F ; G 
print1                          = $000F ; G test
print                           = $000F ; G test
ASMHEAD_data                    = $0015 ; G 
ASMSIZE_code                    = $0015 ; G 
ASMTAIL_code                    = $0015 ; G 
code_end                        = $0015 ; G test
test1_mess                      = $0015 ; L test
test2_mess                      = $001B ; L test
test3_mess                      = $0020 ; L test
test3_dollar                    = $0022 ; L test
ASMSIZE                         = $0024 ; G 
ASMTAIL                         = $0024 ; G 
ASMTAIL_data                    = $0024 ; G 
END

# at address 0x1234
unlink "test.asm", "test.bin";

$cmd = "./z80asm -b -m -r0x1234 test.o";
ok 1, $cmd;
($stdout, $stderr, $return) = capture { system $cmd; };
eq_or_diff_text $stdout, "", "stdout";
eq_or_diff_text $stderr, "", "stderr";
ok !!$return == !!0, "retval";
test_binfile("test.bin", $bincode->(0x1234));

eq_or_diff_text norm_nl(scalar(read_file("test.map"))), norm_nl(<<'END');
ASMSIZE_data                    = $000F ; G 
ASMSIZE_code                    = $0015 ; G 
ASMSIZE                         = $0024 ; G 
ASMHEAD                         = $1234 ; G 
ASMHEAD_code                    = $1234 ; G 
main                            = $1234 ; G test
printa                          = $123B ; G test
test2_printa1                   = $123B ; L test
print1                          = $1243 ; G test
print                           = $1243 ; G test
ASMHEAD_data                    = $1249 ; G 
ASMTAIL_code                    = $1249 ; G 
code_end                        = $1249 ; G test
test1_mess                      = $1249 ; L test
test2_mess                      = $124F ; L test
test3_mess                      = $1254 ; L test
test3_dollar                    = $1256 ; L test
ASMTAIL                         = $1258 ; G 
ASMTAIL_data                    = $1258 ; G 
END


sub norm_nl {
	my($text) = @_;
	$text =~ s/\r?\n/\n/g;
	return $text;
}
