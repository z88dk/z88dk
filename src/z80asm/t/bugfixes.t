#!/usr/bin/perl

#-----------------------------------------------------------------------------
# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2019
# License: http://www.perlfoundation.org/artistic_license_2_0
#
# Test bugfixes
#-----------------------------------------------------------------------------

use Modern::Perl;
use File::Path qw(make_path remove_tree);;
use Path::Tiny;
use Capture::Tiny::Extended 'capture';
BEGIN { 
	use lib '.'; 
	use t::TestZ80asm;
	use t::Listfile;
};

#------------------------------------------------------------------------------
# CH_0001: Assembly error messages should appear on stderr
# BUG_0001: Error in expression during link
# BUG_0001(a): during correction of BUG_0001, new symbol 
z80asm(
	asm => 	<<'ASM',
			;; note: BUG_0001
				JP NN			;; C3 06 00
				JP NN			;; C3 06 00
			NN:

			;; note: BUG_0001(a)
				EXTERN value
				ld a,value - 0	;; 3E 0A
ASM

	asm1 => <<'ASM1',
				PUBLIC value
				DEFC   value = 10
ASM1
);

#------------------------------------------------------------------------------
# BUG_0002 : CreateLibFile and GetLibFile: buffer overrun
note "BUG_0002";
z80asm(
	asm => <<'ASM',
				PUBLIC one
			one: 
				ld a,1
				ret
ASM
	options => "-xtest.lib",
	ok		=> 1,
);

z80asm(
	asm =>	<<'ASM',
				EXTERN one
				jp one			;; C3 03 00 3E 01 C9
ASM
	options => "-itest.lib -b",
);
unlink_temp("test.lib");

#------------------------------------------------------------------------------
# BUG_0003 : Illegal options are ignored, although ReportError 9 (Illegal Option) exists
note "BUG_0003";
z80asm(
	options => "-h=x",
	error 	=> <<'ERR',
Error: illegal option: -h=x
ERR
);

#------------------------------------------------------------------------------
# BUG_0004 : 8bit unsigned constants are not checked for out-of-range
# BUG_0005 : Offset of (ix+d) should be optional; '+' or '-' are necessary
# BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
# BUG_0011 : ASMPC should refer to start of statememnt, not current element in DEFB/DEFW
# BUG_0024 : (ix+128) should show warning message
z80asm(
	asm => <<'ASM',
	;; note: BUG_0004
		ld a, -129			;; 3E 7F 		;; warn: integer '-129' out of range
		ld a,256			;; 3E 00 		;; warn: integer '256' out of range
		ld (ix-129),-1		;; DD 36 7F FF	;; warn: integer '-129' out of range
		ld (ix+128),-1		;; DD 36 80 FF	;; warn: integer '128' out of range

	;; note: BUG_0005
		inc (ix)			;; DD 34 00
		inc (ix + 3)		;; DD 34 03
		inc (ix - 3)		;; DD 34 FD
	
	;; note: BUG_0011
		defb    bug0011a-ASMPC, bug0011a-ASMPC	;; 06 06
		defb    bug0011a-ASMPC, bug0011a-ASMPC	;; 04 04
		defb    bug0011a-ASMPC, bug0011a-ASMPC	;; 02 02
	bug0011a:
	
	;; note: BUG_0024
		inc (ix + 255)		;; DD 34 FF		;; warn: integer '255' out of range
ASM
);

z80asm(
	asm => <<'ASM',
	;; note: BUG_0005
		inc (ix   3)		;; error: syntax error
		
	;; note: BUG_0006
		defb (2				;; error: syntax error in expression
		defb (2+[			;; error: syntax error
		defb (2+[3-1]		;; error: syntax error in expression
		defb (2+[3-1)]		;; error: syntax error in expression
ASM
);

#------------------------------------------------------------------------------
# BUG_0008 : code block of 64K is read as zero
note "BUG_0008";
z80asm(
	asm		=> "defs 65536, 0xAA",
	options	=> " ",
	ok		=> 1,
);

# use .o, dont assemble
z80asm(
	options	=> "-d -b test.o",
	bin		=> "\xAA" x 65536,
	ok		=> 1,
);

#------------------------------------------------------------------------------
# BUG_0010 : heap corruption when reaching MAXCODESIZE
# raise HEAP CORRUPTION DETECTED in MSVC
note "BUG_0010";
z80asm(
	asm		=> "defs 65534,0xAA \n ld a, 0xAA",
	bin		=> "\xAA" x 65534 . "\x3E\xAA",
);
z80asm(
	asm		=> "defs 65535,0xAA \n ld a, 0xAA ;; error: max. code size of 65536 bytes reached",
);
z80asm(
	asm		=> "defs 65533,0xAA \n ld bc, 0xAAAA",
	bin		=> "\xAA" x 65533 . "\x01\xAA\xAA",
);
z80asm(
	asm		=> "defs 65534,0xAA \n ld bc, 0xAAAA ;; error: max. code size of 65536 bytes reached",
);
z80asm(
	asm		=> "defs 65532,0xAA \n defq 0xAAAAAAAA",
	bin		=> "\xAA" x 65536,
);
z80asm(
	asm		=> "defs 65533,0xAA \n defq 0xAAAAAAAA ;; error: max. code size of 65536 bytes reached",
);

#------------------------------------------------------------------------------
# BUG_0012: binfilename[] array is too short, should be FILENAME_MAX
note "BUG_0012";
z80asm(
	asm		=> "nop ;; 00",
	options	=> "-b -o".("./" x 64)."test.bin",
);

#------------------------------------------------------------------------------
# BUG_0013: defm check for MAX_CODESIZE incorrect
note "BUG_0013";
z80asm(
	asm		=> "defs 65535, 'a' \n defm \"a\"",
	bin		=> "a" x 65536,
);

#------------------------------------------------------------------------------
# BUG_0014: -x./zx_clib should create ./zx_clib.lib but actually creates .lib
note "BUG_0014";
for my $lib (      'test',    'test.lib',
				 './test',  './test.lib',
				'.\\test', '.\\test.lib' ) {
	next if ($lib =~ /\\/ && $^O !~ /MSWin32/);
    unlink('test.lib');
    ok ! -f 'test.lib', "test.lib deleted, building $lib";
	z80asm(
		asm		=> "PUBLIC main \n main: ret",
		options	=> "-x".$lib,
		ok		=> 1,
	);
    ok -f 'test.lib', "test.lib exists, built $lib";
	z80asm(
		asm		=> "EXTERN main \n jp main ;; C3 03 00 C9",
		options	=> "-b -i".$lib,
	);
}

#------------------------------------------------------------------------------
# BUG_0015: Relocation issue - dubious addresses come out of linking
note "BUG_0015";
z80asm(
	asm		=> <<'ASM',
				PUBLIC L1

	    L1:		ld l,1		; 802C  2E 01
				jp L2		; 802E  C3 31 80

	    L2:		ld l,2		; 8031  2E 02
				jp L1		; 8033  C3 2C 80
							; 8036
ASM
	options	=> "-xtest.lib",
	ok		=> 1,
);
z80asm(
	asm1	=> <<'ASM1',
				PUBLIC A1, A2
				EXTERN B1, B2, L1

	    A1:		ld a,1		; 8000 ;; 3E 01
				call B1		; 8002 ;; CD 16 80
				call L1		; 8005 ;; CD 2C 80
				jp A2		; 8008 ;; C3 0B 80

	    A2:		ld a,2		; 800B ;; 3E 02
				call B2		; 800D ;; CD 21 80
				call L1		; 8010 ;; CD 2C 80
				jp A1		; 8013 ;; C3 00 80
							; 8016
ASM1
	asm2	=> <<'ASM2',
				PUBLIC B1, B2
				EXTERN A1, A2, L1

	    B1:		ld b,1		; 8016 ;; 06 01
				call A1		; 8018 ;; CD 00 80
				call L1		; 801B ;; CD 2C 80
				jp B2		; 801E ;; C3 21 80

	    B2:		ld b,2		; 8021 ;; 06 02
				call A2		; 8023 ;; CD 0B 80
				call L1		; 8026 ;; CD 2C 80
				jp B1		; 8029 ;; C3 16 80
							; 802C ;; 2E 01
							; 802E ;; C3 31 80
							; 8031 ;; 2E 02
							; 8033 ;; C3 2C 80
							; 8036
ASM2
	options	=> "-itest.lib -b -r0x8000",
);

#------------------------------------------------------------------------------
# BUG_0016: RCM2000 and RCM3000 emulation routines not assembled when LIST is ON (-l)
note "BUG_0016";
for my $list ("", "-l") {
z80asm(
	asm		=> <<'ASM',
			cpi				;; ED A1
ASM
	options	=> "$list -b",
);
z80asm(
	asm		=> <<'ASM',
			cpi				;; CD 03 00
							;; 38 14 BE 23 0B F5 ED 54 CB 85 CB D5 
							;; 78 B1 20 02 CB 95 ED 54 F1 C9 BE 23 
							;; 0B F5 ED 54 CB C5 18 EA
ASM
	options	=> "$list -b -mr2k",
);
}

#------------------------------------------------------------------------------
# BUG_0018: stack overflow in '@' includes - wrong range check
note "BUG_0018";
{
	my $levels = 64;
	
	write_file("test.lst", "\@test0.lst");
	my $bin = "";
	for (0 .. $levels) {
		write_file("test$_.lst", 
				   "test$_.asm\n",
				   "\@test".($_+1).".lst\n");
		write_file("test$_.asm", "defb $_");
		$bin .= chr($_);
	}
	write_file("test".($levels+1).".lst", "");

	z80asm(
		options	=> "-b -otest.bin \"\@test.lst\"",
		bin		=> $bin,
	);
}

#------------------------------------------------------------------------------
# BUG_0020: Segmentation fault in ParseIdent for symbol not found with interpret OFF
note "BUG_0020";
z80asm(
	asm		=> <<'ASM',
		IF CC
		invalid		;; error: syntax error
		ENDIF
ASM
	options	=> "-b -DCC",
);
z80asm(
	asm		=> <<'ASM',
		IF CC
		invalid
		ENDIF
		defb 0		;; 00
ASM
	options	=> "-b",
);

#------------------------------------------------------------------------------
# BUG_0023: Error file with warning is removed in link phase
note "BUG_0023";
z80asm(
	asm		=> "ld a,-129 ;; 3E 7F ;; warn: integer '-129' out of range",
);
is_text(scalar(read_file("test.err")), <<'ERROR');
Warning at file 'test.asm' line 1: integer '-129' out of range
ERROR

z80asm(
	asm  	=> <<'ASM',
			EXTERN value
			ld a,value		;; 3E 7F ;; warn 3: integer '-129' out of range
			ld b,256		;; 06 00 ;; warn 2: integer '256' out of range
ASM
	asm1	=> <<'ASM1',
			PUBLIC value
			defc value = -129
ASM1
);
is_text(scalar(read_file("test.err")), <<'ERROR');
Warning at file 'test.asm' line 3: integer '256' out of range
Warning at file 'test.asm' line 2: integer '-129' out of range
ERROR

#------------------------------------------------------------------------------
# BUG_0033 : -d option fails if .asm does not exist
SKIP: {
	skip "zcc needs to be fixed to not call z80asm -ns", 1;
	
	note "BUG_0033";
	{
		# compile
		my $compile = "zcc +zx -O3 -vn -make-lib -Wn43 test.c";
		unlink("test.asm", "test.o");
		
		write_file("test.c", "int test() { return 1; }\n");
		ok ! system($compile), $compile;
		ok -f "test.o", "test.o exists";

		z80asm(
			options	=> "-d -xtest.lib test.asm",
			ok		=> 1,
		);
		ok -f "test.lib", "test.lib exists";

		unlink("zcc_opt.def");
		
		# only assembly
		z80asm(
			asm		=> "ld a,3",
			options	=> " ",
			ok		=> 1,
		);
		ok unlink("test.asm"), "unlink test.asm";
		z80asm(
			options	=> "-d -b test.asm",
			bin		=> "\x3E\x03",
		);
	}
};

#------------------------------------------------------------------------------
# BUG_0035 : Symbol not defined in forward references
note "BUG_0035";
z80asm(
	asm		=> <<'ASM',
			call loop			;; CD 06 00
			call loop 			;; CD 06 00
		loop:
			ret					;; C9
ASM
);

#------------------------------------------------------------------------------
# BUG_0037 : Symbol already defined error when symbol used in IF expression
note "BUG_0037";
z80asm(
	asm		=> <<'ASM',
			IF !NEED_floatpack
				DEFINE	NEED_floatpack
			ENDIF
			defb NEED_floatpack		;; 01
ASM
);
z80asm(
	asm		=> <<'ASM',
			IF !NEED_floatpack
				DEFINE	NEED_floatpack
			ENDIF
			defb NEED_floatpack		;; 01
ASM
	options	=> "-DNEED_floatpack -b"
);

#------------------------------------------------------------------------------
# BUG_0047 : Expressions including ASMPC not relocated - impacts call po|pe|p|m emulation in RCM2000
note "BUG_0047";
z80asm(
	asm		=> <<'ASM',
			bug0047a:
				defw	ASMPC,ASMPC,ASMPC	;; 00 01 00 01 00 01
			bug0047b:	
				jp		ASMPC				;; C3 06 01
ASM
	options	=> "-r0x100 -b",
);

#------------------------------------------------------------------------------
# BUG_0050: Making a library with more than 64K and -d option fails - max. code size reached
note "BUG_0050";
z80asm(
	asm1 =>	"defs 65000",
	asm2 =>	"defs 65000",
	options => "-Dxxx",		# no -b
	ok => 1,
);
z80asm(
	options => "-d -xtest.lib test1 test2",
	ok => 1,
);

#------------------------------------------------------------------------------
# http://www.z88dk.org/forum/viewtopic.php?id=8561
# It looks like a z80asm bug with defc.  
# "DEFC L_DIVENTRY = entry - l_div_u" should result in a small positive
# constant and " l_div_u + L_DIVENTRY" should not evaluate to a large positive
# number or a small negative one.
# Expression evaluator needs to recognize that a subtraction of two
# labels defined in the same module is a contant and not an address.
# Remove '#' operator after this is fixed.

z80asm(
	asm => <<'...',
		EXTERN l_div

		call l_div					; 0000 ;; CD 04 00
		ret							; 0003 ;; C9
...
	asm1 => <<'...',
		PUBLIC l_div
		EXTERN l_div_u, L_DIVENTRY
		
	l_div:
		call l_div_u + L_DIVENTRY	; 0004 ;; CD 0D 00
		ret							; 0007 ;; C9
...
	asm2 => <<'...',
		PUBLIC l_div_u, L_DIVENTRY
		
	l_div_u:
		nop							; 0008 ;; 00
		nop							; 0009 ;; 00
		nop							; 000A ;; 00
		nop							; 000B ;; 00
		nop							; 000C ;; 00
	entry:
		ret							; 000D ;; C9
		
		DEFC L_DIVENTRY = # entry - l_div_u
...
);

#------------------------------------------------------------------------------
# Bug report: z80asm: bug with relative jumps across sections
# alvin (alvin_albrecht@hotmail.com) <lists@suborbital.org.uk> 	Sun, Oct 16, 2016 at 6:30 PM
# JR across sections generate wrong code
for my $op ("jr", "djnz", "jr nc,") {
	write_file("test.asm", <<"...");
		SECTION LOADER
		$op 0+(pietro_loader)
		
		SECTION LOADER_CODE
	pietro_loader:
		ret
...
	my $cmd = "z80asm -b test.asm";
	ok 1, $cmd;
	my($stdout, $stderr, $return) = capture { system $cmd; };
	is_text( $stdout, "", "stdout" );
	is_text( $stderr, <<'...', "stderr" );
Error at file 'test.asm' line 2: relative jump address must be local
...
	ok !!$return == !!1, "retval";
}
