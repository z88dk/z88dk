#!/usr/bin/perl

#     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
#   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
#                ZZZZZ      888           888  0000         0000
#              ZZZZZ        88888888888888888  0000         0000
#            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
#          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
#        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
#      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
#    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
#  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM
#
# Copyright (C) Paulo Custodio, 2011-2014

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/bugfixes.t,v 1.33 2014-05-20 22:26:29 pauloscustodio Exp $
#
# Test bugfixes

use Modern::Perl;
use File::Path qw(make_path remove_tree);;
use t::TestZ80asm;
use t::Listfile;

#------------------------------------------------------------------------------
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
$ENV{Z80_STDLIB} = "test.lib";
z80asm(
	asm => <<'ASM',
				PUBLIC one
			one: 
				ld a,1
				ret
ASM
	options => "-x",
	ok		=> 1,
);

z80asm(
	asm =>	<<'ASM',
				EXTERN one
				jp one			;; C3 03 00 3E 01 C9
ASM
	options => "-i -b -r0",
);
delete $ENV{Z80_STDLIB};
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
# BUG_0007 : memory leaks
# BUG_0011 : ASMPC should refer to start of statememnt, not current element in DEFB/DEFW
# BUG_0024 : (ix+128) should show warning message
# BUG_0032 : DEFGROUP ignores name after assignment
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
	
	;; note: BUG_0032
		defgroup
		{
			f10 = 10, f11
		}
		defb f10, f11		;; 0A 0B
	
ASM
);

z80asm(
	asm => <<'ASM',
	;; note: BUG_0005
		inc (ix   3)		;; error: syntax error
		
	;; note: BUG_0006
		defb (2				;; error: syntax error in expression
		defb (2+[			;; error: syntax error in expression
		defb (2+[3-1]		;; error: syntax error in expression
		defb (2+[3-1)]		;; error: syntax error in expression

	;; note: BUG_0007
		defs not_defined	;; error: symbol not defined
		
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

# use obj, dont assemble
z80asm(
	options	=> "-d -r0 -b test.obj",
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
	asm		=> "defs 65532,0xAA \n defl 0xAAAAAAAA",
	bin		=> "\xAA" x 65536,
);
z80asm(
	asm		=> "defs 65533,0xAA \n defl 0xAAAAAAAA ;; error: max. code size of 65536 bytes reached",
);

#------------------------------------------------------------------------------
# BUG_0012: binfilename[] array is too short, should be FILENAME_MAX
note "BUG_0012";
z80asm(
	asm		=> "nop ;; 00",
	options	=> "-r0 -b -o".("./" x 64)."test.bin",
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
		options	=> "-r0 -b -i".$lib,
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
	options	=> "-itest.lib -b -r8000",
);

#------------------------------------------------------------------------------
# BUG_0016: RCMX000 emulation routines not assembled when LIST is ON (-l)
note "BUG_0016";
for my $list ("", "-l") {
z80asm(
	asm		=> <<'ASM',
			cpi				;; ED A1
ASM
	options	=> "-i".z80emu()." $list -b -r0",
);
z80asm(
	asm		=> <<'ASM',
			cpi				;; CD 03 00
							;; 38 12 BE 23 0B F5 E3 CB 85 CB D5 78
							;; B1 20 02 CB 95 E3 F1 C9 BE 23 0B F5
							;; E3 CB C5 18 EC
ASM
	options	=> "-i".z80emu()." $list -b -r0 -RCMX000",
);
}

#------------------------------------------------------------------------------
# BUG_0017 : no error message if fails to create binary file chunk (option -c)
note "BUG_0017";
make_path('test.bn1');	# make it impossible to create one of the bin files
z80asm(
	asm		=> "defs 0x10000",
	error	=> "Error: cannot write file 'test.bn1'",
	options	=> "-r0 -b -c",
);
remove_tree('test.bn1');

#------------------------------------------------------------------------------
# BUG_0018: stack overflow in '@' includes - wrong range check
note "BUG_0018";
{
	my $levels = 64;
	
	write_file("test.prj", "\@test0.prj");
	my $bin = "";
	for (0 .. $levels) {
		write_file("test$_.prj", 
				   "test$_.asm\n",
				   "\@test".($_+1).".prj\n");
		write_file("test$_.asm", "defb $_");
		$bin .= chr($_);
	}
	write_file("test".($levels+1).".prj", "");

	z80asm(
		options	=> "-r0 -b -ns -nm -otest.bin \@test.prj",
		bin		=> $bin,
	);
}

#------------------------------------------------------------------------------
# BUG_0020: Segmentation fault in ParseIdent for symbol not found with interpret OFF
note "BUG_0020";
z80asm(
	asm		=> <<'ASM',
		IF C
		invalid		;; error: unknown identifier
		ENDIF
ASM
	options	=> "-r0 -b -DC",
);
z80asm(
	asm		=> <<'ASM',
		IF C
		invalid
		ENDIF
		defb 0		;; 00
ASM
	options	=> "-r0 -b",
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
			ld a,value 		;; 3E 7F 
			ld b,256		;; 06 00 ;; warn: integer '256' out of range
;; warn: integer '-129' out of range in expression 'value'
ASM
	asm1	=> <<'ASM1',
			PUBLIC value
			defc value = -129
ASM1
);
eq_or_diff(scalar(read_file("test.err")), <<'ERROR');
Warning at file 'test.asm' line 3: integer '256' out of range
Warning at file 'test.asm' module 'test': integer '-129' out of range in expression 'value'
ERROR

#------------------------------------------------------------------------------
# BUG_0025 : JR at org 0 with out-of-range jump crashes WriteListFile()
for ('jr', 'djnz')
{
	z80asm(
		asm		=> "$_ ASMPC+2-129 ;; error: integer '-129' out of range",
	);

	z80asm(
		asm		=> "$_ ASMPC+2+128 ;; error: integer '128' out of range",
	);
}

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
	my @vars  = ('A' .. 'Z') x 10;

	my $list = t::Listfile->new();
	for ([defb => "C"], [defw => "v"], [defl => "V"]) {
		my($opcode, $pack) = @$_;
		
		for (0 .. $#items) {
			my $asm = "$opcode ".join(",", @vars[0 .. $_]);
			last if length($asm) > t::Listfile->max_line();
			
			$list->push_asm($asm, unpack("C*", pack("$pack*", @items[0 .. $_])));
		}
	}
	for (0 .. 25) {		
		$list->push_asm("defc ".chr(ord('A')+$_)." = $_");
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
	$list->push_asm("defb ".join(",", ('P') x $num), (0x12) x $num);
	$list->push_asm("defc P = 0x12");
	$list->test();
}

#------------------------------------------------------------------------------
# BUG_0031 : List file garbled with input lines with 255 chars
note "BUG_0031";
{
	my $list = t::Listfile->new();
	my $num = int((255-5)/2);
	$list->push_asm("defb ".join(",", ('P') x $num), (0x12) x $num) for (1..4);
	$list->push_asm("defc P = 0x12");
	$list->test();
}

#------------------------------------------------------------------------------
# BUG_0033 : -d option fails if .asm does not exist
note "BUG_0033";
{
	# compile
	my $compile = "zcc +zx -O3 -vn -make-lib -Wn43 test.c";
	unlink("test.asm", "test.o");
	
	write_file("test.c", "int test() { return 1; }\n");
	ok ! system($compile), $compile;
	ok -f "test.o", "test.o exists";

	z80asm(
		options	=> "-d -Mo -xtest.lib test.asm",
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
		options	=> "-d -r0 -b test.asm",
		bin		=> "\x3E\x03",
	);
}

#------------------------------------------------------------------------------
# BUG_0034 : If assembly process fails with fatal error, invalid library is kept
note "BUG_0034";
unlink("test.lib");
z80asm(
	asm		=> <<'ASM',
		include "FILE_NOT_FOUND"	;; error: cannot read file 'FILE_NOT_FOUND'
ASM
	options	=> "-xtest.lib",
);
ok ! -f "test.lib", "test.lib does not exist";

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
# BUG_0047 : Expressions including ASMPC not relocated - impacts call po|pe|p|m emulation in RCMX000
note "BUG_0047";
z80asm(
	asm		=> <<'ASM',
			bug0047a:
				defw	ASMPC,ASMPC,ASMPC	;; 00 01 00 01 00 01
			bug0047b:	
				jp		ASMPC				;; C3 06 01
ASM
	options	=> "-r100 -b",
);

#------------------------------------------------------------------------------
# BUG_0049: Making a library with -d and 512 object files fails - Too many open files
note "BUG_0049";
{
	my @list;
	my %args;
	for (1..512) {
		my $id = sprintf("%03d", $_);
		unlink("test$id.asm", "test$id.obj", "test$id.bin");
		push @list, "test$id";
		$args{"asm$id"} = "defw $_ ;; ".sprintf("%02X %02X", $_ & 255, $_ >> 8);
	}
	write_file("test.prj", join("\n", @list), "\n");
	
	# assemble all first
	z80asm( %args, options => '   -ns -nm -r0 -b @test.prj' );
	
	# assemble all with -d, make lib - failed with too many open files
	z80asm( %args, options => '-d -ns -nm -r0 -b @test.prj' );
}

#------------------------------------------------------------------------------
# BUG_0050: Making a library with more than 64K and -d option fails - max. code size reached
note "BUG_0050";
z80asm(
	asm1 =>	"defs 65000",
	asm2 =>	"defs 65000",
	options => "-ns -nm",
	ok => 1,
);
z80asm(
	options => "-d -ns -nm -xtest.lib test1 test2",
	ok => 1,
);

#------------------------------------------------------------------------------
# BUG_0051: DEFC and DEFVARS constants do not appear in map file
note "BUG_0051";
{
	z80asm(
		asm		=> <<'ASM',
			public minus_d_var, defc_var, defvars_var, public_label
			defc defc_var = 2
			defvars 3 { 
			defvars_var ds.b 1
			}
		public_label: 
			defb minus_d_var	;; 01
			defb defc_var		;; 02
			defb defvars_var	;; 03
			defb public_label	;; 04
			defb local_label 	;; 09
		local_label:
ASM
		options	=> "-r4 -b -m -g -Dminus_d_var"
	);

	eq_or_diff scalar(read_file("test.def")), <<'END', "test.def";
DEFC public_label                    = $0004 ; Module test
END

	eq_or_diff scalar(read_file("test.map")), <<'END', "test.map";
ASMHEAD                         = 0004, G: 
ASMSIZE                         = 0005, G: 
ASMTAIL                         = 0009, G: 
defc_var                        = 0002, G: test
defvars_var                     = 0003, G: test
local_label                     = 0009, L: test
minus_d_var                     = 0001, G: test
public_label                    = 0004, G: test


minus_d_var                     = 0001, G: test
defc_var                        = 0002, G: test
defvars_var                     = 0003, G: test
ASMHEAD                         = 0004, G: 
public_label                    = 0004, G: test
ASMSIZE                         = 0005, G: 
ASMTAIL                         = 0009, G: 
local_label                     = 0009, L: test
END
}


# $Log: bugfixes.t,v $
# Revision 1.33  2014-05-20 22:26:29  pauloscustodio
# BUG_0051: DEFC and DEFVARS constants do not appear in map file
# Constants defined with DEFC and DEFVARS, and declared PUBLIC are not
# written to the map file.
# Logic to select symbols for map and def files was wrong.
#
# Revision 1.32  2014/05/14 22:17:03  pauloscustodio
# Move tests of BUG_0035 to bugfixes.t
#
# Revision 1.31  2014/05/14 22:10:26  pauloscustodio
# Move tests of BUG_0034 to bugfixes.t
#
# Revision 1.30  2014/05/14 22:04:15  pauloscustodio
# Move tests of BUG_0033 to bugfixes.t
#
# Revision 1.29  2014/05/14 21:29:47  pauloscustodio
# Move tests of BUG_0032 to bugfixes.t
#
# Revision 1.28  2014/05/13 23:45:36  pauloscustodio
# Move tests of BUG_0047 to bugfixes.t
#
# Revision 1.27  2014/05/11 17:25:37  pauloscustodio
# Move tests of BUG_0031 to bugfixes.t
#
# Revision 1.26  2014/05/11 17:21:37  pauloscustodio
# Move tests of BUG_0030 to bugfixes.t
#
# Revision 1.25  2014/05/11 17:17:25  pauloscustodio
# Move tests of BUG_0029 to bugfixes.t
#
# Revision 1.24  2014/05/11 17:10:08  pauloscustodio
# Move tests of BUG_0028 to bugfixes.t
#
# Revision 1.23  2014/05/11 16:45:38  pauloscustodio
# Move tests of BUG_0027 to bugfixes.t
#
# Revision 1.22  2014/05/11 16:35:42  pauloscustodio
# Move tests of BUG_0026 to bugfixes.t
#
# Revision 1.21  2014/05/09 23:20:57  pauloscustodio
# Move tests of BUG_0025 to bugfixes.t
#
# Revision 1.20  2014/05/09 23:13:20  pauloscustodio
# Move tests of BUG_0024 to bugfixes.t
#
# Revision 1.19  2014/05/08 22:52:23  pauloscustodio
# Move tests of BUG_0023 to bugfixes.t
#
# Revision 1.18  2014/05/08 22:30:38  pauloscustodio
# Move tests of BUG_0020 to bugfixes.t
#
# Revision 1.17  2014/05/08 22:09:37  pauloscustodio
# Move tests of BUG_0018 to bugfixes.t
#
# Revision 1.16  2014/05/07 23:18:16  pauloscustodio
# Move tests of BUG_0017 to bugfixes.t
#
# Revision 1.15  2014/05/07 23:09:26  pauloscustodio
# Move tests of BUG_0016 to bugfixes.t
#
# Revision 1.14  2014/05/07 22:41:20  pauloscustodio
# Move tests of BUG_0015 to bugfixes.t
#
# Revision 1.13  2014/05/05 22:03:57  pauloscustodio
# Move tests of BUG_0014 to bugfixes.t
#
# Revision 1.12  2014/05/05 21:51:41  pauloscustodio
# Move tests of BUG_0013 to bugfixes.t
#
# Revision 1.11  2014/05/05 21:47:35  pauloscustodio
# Move tests of BUG_0012 to bugfixes.t
#
# Revision 1.10  2014/05/05 21:40:24  pauloscustodio
# Move tests of BUG_0011 to bugfixes.t
#
# Revision 1.9  2014/05/04 19:04:55  pauloscustodio
# Move tests of BUG_0010 to bugfixes.t
#
# Revision 1.8  2014/05/04 18:46:46  pauloscustodio
# Move tests of BUG_0008 to bugfixes.t
#
# Revision 1.7  2014/05/04 18:05:39  pauloscustodio
# Fix memory leak
#
# Revision 1.6  2014/05/04 17:51:43  pauloscustodio
# Move tests of BUG_0006 to bugfixes.t
#
# Revision 1.5  2014/05/04 17:45:21  pauloscustodio
# Move tests of BUG_0005 to bugfixes.t
#
# Revision 1.4  2014/05/04 17:36:16  pauloscustodio
# Move tests of BUG_0004 to bugfixes.t
#
# Revision 1.3  2014/05/04 16:48:52  pauloscustodio
# Move tests of BUG_0001 and BUG_0002 to bugfixes.t, using TestZ80asm.pm
#
# Revision 1.2  2014/04/26 09:25:32  pauloscustodio
# BUG_0050: Making a library with more than 64K and -d option fails - max. code size reached
# When a library is built with -d, and the total size of the loaded
# modules is more than 64K, z80asm fails with "max. code size reached".
#
# Revision 1.1  2014/04/26 08:12:04  pauloscustodio
# BUG_0049: Making a library with -d and 512 object files fails - Too many open files
# Error caused by z80asm not closing the intermediate object files, when
# assembling with -d.
#
