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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/bugfixes.t,v 1.20 2014-05-09 23:13:20 pauloscustodio Exp $
#
# Test bugfixes

use Modern::Perl;
use File::Path qw(make_path remove_tree);;
use t::TestZ80asm;

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


# $Log: bugfixes.t,v $
# Revision 1.20  2014-05-09 23:13:20  pauloscustodio
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
