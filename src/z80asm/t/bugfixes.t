#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Test bugfixes

use Modern::Perl;
use File::Path qw(make_path remove_tree);;
use Path::Tiny;
use Capture::Tiny::Extended 'capture';
use t::TestZ80asm;
use t::Listfile;

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
Error: illegal option '-h=x'
Error: source filename missing
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
# BUG_0016: RCMX000 emulation routines not assembled when LIST is ON (-l)
note "BUG_0016";
for my $list ("", "-l") {
z80asm(
	asm		=> <<'ASM',
			cpi				;; ED A1
ASM
	options	=> "-i".z80emu()." $list -b",
);
z80asm(
	asm		=> <<'ASM',
			cpi				;; CD 03 00
							;; 38 12 BE 23 0B F5 E3 CB 85 CB D5 78
							;; B1 20 02 CB 95 E3 F1 C9 BE 23 0B F5
							;; E3 CB C5 18 EC
ASM
	options	=> "-i".z80emu()." $list -b --RCMX000",
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
		options	=> "-b -otest.bin \@test.lst",
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
eq_or_diff(scalar(read_file("test.err")), <<'ERROR');
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
eq_or_diff(scalar(read_file("test.err")), <<'ERROR');
Warning at file 'test.asm' line 3: integer '256' out of range
Warning at file 'test.asm' line 2: integer '-129' out of range
ERROR

#------------------------------------------------------------------------------
# BUG_0026 : Incorrect paging in symbol list
note "BUG_0026";
{
	my $list = t::Listfile->new();
	for (0 .. 255) {
		$list->push_asm("PUBLIC GLOBAL$_");
		$list->push_asm("GLOBAL$_: defb $_", $_);
		$list->push_asm("LOCAL$_: defb $_", $_);
	}
	$list->test();	
}

#------------------------------------------------------------------------------
# BUG_0027 : Incorrect tabulation in symbol list
note "BUG_0027";
{
	my $list = t::Listfile->new();
	for (1..255) {
		my $label = substr("X_".sprintf("%03d", $_).('_X' x $_), 0, $_);
				
		my $asm = "$label: defb $_";
		last if length($asm) >= t::Listfile->max_line();
		
		$list->push_asm($asm, $_);
	}		
	$list->test();	
}

#------------------------------------------------------------------------------
# BUG_0028 : Not aligned page list in symbol list with more that 18 references
note "BUG_0028";
{
	my $list = t::Listfile->new();
	
	# very long reference list, one defined before reference, other defined after reference
	$list->push_asm("LBL1:");
	for (0 .. 255) {
		$list->push_asm("defw LBL1", 0, 0);
		$list->push_asm("defw LBL2", 0, 4);

		$list->push_asm(";") for (1..61-2);	# force new page
	}		
	$list->push_asm("LBL2:");
	$list->test();	
}

#------------------------------------------------------------------------------
# BUG_0029 : Incorrect alignment in list file with more than 4 bytes opcode
note "BUG_0029";
{
	my @items = ( 0  ..  25) x 10;
	my @vars  = map {$_."1"} ('A' .. 'Z') x 10;

	my $list = t::Listfile->new();
	for ([defb => "C"], [defw => "v"], [defq => "V"]) {
		my($opcode, $pack) = @$_;
		
		for (0 .. $#items) {
			my $asm = "$opcode ".join(",", @vars[0 .. $_]);
			last if length($asm) > t::Listfile->max_line();
			
			$list->push_asm($asm, unpack("C*", pack("$pack*", @items[0 .. $_])));
		}
	}
	for (0 .. 25) {		
		$list->push_asm("defc ".chr(ord('A')+$_)."1 = $_");
	}
	$list->test();	
}

#------------------------------------------------------------------------------
# BUG_0030 : List bytes patching overwrites header
note "BUG_0030";
{
	my $list = t::Listfile->new();
	my $num = (t::Listfile->max_line() - 5) / 2;		# max number of operands
	$list->push_asm(";") for (1..60);
	$list->push_asm("defb ".join(",", ('X') x $num), (0x12) x $num);
	$list->push_asm("defc X = 0x12");
	$list->test();
}

#------------------------------------------------------------------------------
# BUG_0031 : List file garbled with input lines with 255 chars
note "BUG_0031";
{
	my $list = t::Listfile->new();
	my $num = int((255-5)/2);
	$list->push_asm("defb ".join(",", ('X') x $num), (0x12) x $num) for (1..4);
	$list->push_asm("defc X = 0x12");
	$list->test();
}

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
# BUG_0047 : Expressions including ASMPC not relocated - impacts call po|pe|p|m emulation in RCMX000
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
# BUG_0049: Making a library with -d and 512 (win32) object files fails - Too many open files
# limits very per OS:
# 509 files - when compiled with Visual Studio on Win32
# 3197 files - when compiled with gcc on Cygwin on Win32
# 2045 files - when compiled with gcc on Linux Subsystem for Windows
# 1021 files - when compiled with gcc on Ubuntu
note "BUG_0049";
{
	# build asm files
	my @list;
	my $bin = "";
	for my $n (1..4096) {
		my $id = sprintf("%04d", $n);
		unlink("test$id.o", "test$id.bin", "test$id.err");
		path("test$id.asm")->spew(<<END);
			public lbl$id
			defw $n
			defc lbl$id = $n
END
		push @list, "test$id";
		
		$bin .= pack("v", $n);
	}
	
	# assemble
	unlink 'test0001.bin';
	write_file("test.lst", join("\n", @list), "\n");
	my $cmd = './z80asm -b @test.lst';
	ok 1, $cmd;
	my($out, $err, $ret) = capture { system $cmd; };
	is $out, "";
	is $err, "";
	is $ret, 0;
	test_binfile('test0001.bin', $bin);

	# link only
	unlink 'test0001.bin';
	for (@list) { unlink "$_.asm"; }
	ok 1, $cmd;
	($out, $err, $ret) = capture { system $cmd; };
	is $out, "";
	is $err, "";
	is $ret, 0;
	test_binfile('test0001.bin', $bin);
	
	# make library
	unlink 'test.lib';
	$cmd = './z80asm -b -xtest @test.lst';
	ok 1, $cmd;
	($out, $err, $ret) = capture { system $cmd; };
	is $out, "";
	is $err, "";
	is $ret, 0;
	ok -f 'test.lib';
	
	# use library
	unlink 'test.bin';
	path('test.asm')->spew(<<'END');
	extern lbl1234;
	defw lbl1234;
END
	$cmd = './z80asm -b -itest test.asm';
	ok 1, $cmd;
	($out, $err, $ret) = capture { system $cmd; };
	is $out, "";
	is $err, "";
	is $ret, 0;
	test_binfile('test.bin', pack("v*", 1234, 1234));

	# delete test files
	for ('test', @list) { unlink "$_.asm", "$_.o", "$_.bin", "$_.err", "$_.lib"; }
}

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
# Bug report:
# alvin (alvin_albrecht@hotmail.com) <lists@suborbital.org.uk> Fri, Dec 4, 2015 at 3:11 AM 
# To: z88dk-developers@lists.sourceforge.net 
# The two labels are not equal despite the defc.
# When the expression to be computed is based on symbols from different sections
# or modules, the evaluation needs to be postponed to the link phase.
z80asm(
	asm => <<'...',
		SECTION AAA
		org 0
		SECTION BBB
		SECTION CCC


		SECTION AAA
		defw var_1			;; 02 00

		SECTION BBB

		var_1:
		defb 205			;; CD

		SECTION CCC
		defw var_1			;; 02 00	

		defc var_2 = var_1
...
	options => "-b -m",
	bin_file => "test_AAA.bin",
);
eq_or_diff scalar(read_file("test.map")), <<'...', "mapfile contents";
__AAA_head                      = $0000 ; G 
__head                          = $0000 ; G 
__BBB_size                      = $0001 ; G 
__AAA_size                      = $0002 ; G 
__AAA_tail                      = $0002 ; G 
__BBB_head                      = $0002 ; G 
__CCC_size                      = $0002 ; G 
var_1                           = $0002 ; L test
var_2                           = $0002 ; L test
__BBB_tail                      = $0003 ; G 
__CCC_head                      = $0003 ; G 
__CCC_tail                      = $0005 ; G 
__size                          = $0005 ; G 
__tail                          = $0005 ; G 
...

z80asm(
	asm => <<'...',
		SECTION AAA
		org 0
		SECTION BBB
		SECTION CCC


		SECTION AAA
		defw var_1			;; 02 00

		SECTION BBB

		var_1:
		defb 205			;; CD

		SECTION CCC
		defw var_1			;; 02 00

		SECTION BBB
		defc var_2 = var_1
...
	options => "-b -m",
	bin_file => "test_AAA.bin",
);
eq_or_diff scalar(read_file("test.map")), <<'...', "mapfile contents";
__AAA_head                      = $0000 ; G 
__head                          = $0000 ; G 
__BBB_size                      = $0001 ; G 
__AAA_size                      = $0002 ; G 
__AAA_tail                      = $0002 ; G 
__BBB_head                      = $0002 ; G 
__CCC_size                      = $0002 ; G 
var_1                           = $0002 ; L test
var_2                           = $0002 ; L test
__BBB_tail                      = $0003 ; G 
__CCC_head                      = $0003 ; G 
__CCC_tail                      = $0005 ; G 
__size                          = $0005 ; G 
__tail                          = $0005 ; G 
...

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
	my $cmd = "./z80asm -b test.asm";
	ok 1, $cmd;
	my($stdout, $stderr, $return) = capture { system $cmd; };
	eq_or_diff_text $stdout, "", "stdout";
	eq_or_diff_text $stderr, <<'...', "stderr";
Error at file 'test.asm' line 2: relative jump address must be local
1 errors occurred during assembly
...
	ok !!$return == !!1, "retval";
}
