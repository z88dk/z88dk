#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Test asmpp.pl

use strict;
use warnings;
use Test::More;
use File::Slurp;
use Test::Differences;
use Capture::Tiny::Extended 'capture';

require 't/test_utils.pl';

#------------------------------------------------------------------------------
# simple code
#------------------------------------------------------------------------------
t_asmpp_ok(" nop", "", "\x00");

#------------------------------------------------------------------------------
# macros
#------------------------------------------------------------------------------
t_asmpp_error(<<'...', "", <<'...');
m1	macro
	nop
	endm
m1	macro
	nop
	endm
...
Error at file test.asm line 4: macro multiply defined
...

t_asmpp_error(<<'...', "", <<'...');
m1	macro
	nop
...
Error at file test.asm line 1: missing ENDM
...

for my $sep ("\t", ":", " :", ": ", " : ") {
	t_asmpp_ok("m1".$sep."macro\n nop\n endm\n m1", "", "\x00");
}

t_asmpp_error(<<'...', "", <<'...');
m1	macro
	nop
	endm
	
	m1 a
...
Error at file test.asm line 5: extra macro arguments
...

t_asmpp_ok(<<'...', "", "\xC5\xD5\xE5\xF5" x 5);
pusha	macro
		push bc
		push de
		push hl
		push af
		endm

s1		pusha
s2 :	pusha
 s3 :	pusha
 . s4	pusha
		pusha
...

t_asmpp_ok(<<'...', "", pack("C*", 1..6));
m1		macro #1,#2,#3	; comment
		defb #1,#2,#3	; comment
		endm			; comment
		
		m1 1 , 2 , 3  	; comment
		m1 4 , 5 , 6  	; comment
...

t_asmpp_ok(<<'...', "", "endmhello");
m1		macro #str
		defm "endm" ; fake endm
		defm "#str"
		endm
		
		m1 "hello" ; unquote quoted args
...

t_asmpp_ok(<<'...', "", "\xC3\x03\x00");
m1		macro
		jp next
next:
		endm
		
		m1
...

t_asmpp_error(<<'...', "", <<'...');
m1		macro
		jp next
next:
		endm
		
		m1
		m1
...
Error at file 'test.asm' line 7: symbol 'next' already defined
1 errors occurred during assembly
...

t_asmpp_ok(<<'...', "", "\xC3\x03\x00\xC3\x06\x00");
m1		macro
		local #next
		jp #next
#next:
		endm
		
		m1
		m1
...

#------------------------------------------------------------------------------
# expressions
#------------------------------------------------------------------------------
t_asmpp_ok(<<'...', "",
		defc value = 0x1234					; line 1
		defm "hello"						; line 2
		defb 32								; line 3
		defm 'world!'						; line 4
		defb 4ah,$4b,#4c,&h4d,0x4e			; line 5
		DEFB 4AH,$4B,#4C,&H4D,0X4E			; line 6
		defb 1b,%10,@11,&b100,0b101			; line 7
		DEFB 1B,%10,@11,&B100,0B101			; line 8
		defb 0.and.1,0.or.1,0.xor.0,.not.0	; line 9
		DEFB 0.AND.1,0.OR.1,0.XOR.0,.NOT.0	; line 10
		defb 1.shl.2,4.shr.2				; line 11
		DEFB 1.SHL.2,4.SHR.2				; line 12
		defb 2.equ.3,2.lt.3,2.gt.3			; line 13
		DEFB 2.EQU.3,2.LT.3,2.GT.3			; line 14
		defb @'-',@'#',@"#-",@"##"			; line 15
		defb %'-',%'#',%"#-",%"##"			; line 16
		defb .high. + 65534,.HIGH. ( 0xFF << 8 )	; line 17
		defb .high. + value,.HIGH. ( value - 256 )	; line 18
		defb .low. + 65534,.LOW. ( 0xFE00 >> 8 )	; line 19
		defb .low. + value,.LOW. ( value - 1 )		; line 20
...
		"hello" .							# line 2
		" " .								# line 3
		"world!" .							# line 4
		"JKLMN" .							# line 5
		"JKLMN" . 							# line 6
		"\1\2\3\4\5" .						# line 7
		"\1\2\3\4\5" .						# line 8
		"\0\1\0\1" .						# line 9
		"\0\1\0\1" .						# line 10
		"\4\1" .							# line 11
		"\4\1" .							# line 12
		"\0\1\0" .							# line 13
		"\0\1\0" .							# line 14
		"\0\1\2\3" .						# line 15
		"\0\1\2\3" .						# line 16
		"\xFF\xFF" .						# line 17
		"\x12\x11" .						# line 18
		"\xFE\xFE" .						# line 19
		"\x34\x33" .						# line 20
		""
);
t_text(scalar(read_file("test.i")), <<'...');
;;test.asm:1
		defc value = 4660
;;test.asm:2
		DEFB 104,101,108,108,111
;;test.asm:3
		defb 32
;;test.asm:4
		DEFB 119,111,114,108,100,33
;;test.asm:5
		defb 74,75,76,77,78
;;test.asm:6
		DEFB 74,75,76,77,78
;;test.asm:7
		defb 1,2,3,4,5
;;test.asm:8
		DEFB 1,2,3,4,5
;;test.asm:9
		defb 0 & 1,0 | 1,0 ^ 0, ! 0
;;test.asm:10
		DEFB 0 & 1,0 | 1,0 ^ 0, ! 0
;;test.asm:11
		defb 1 << 2,4 >> 2
;;test.asm:12
		DEFB 1 << 2,4 >> 2
;;test.asm:13
		defb 2 == 3,2 < 3,2 > 3
;;test.asm:14
		DEFB 2 == 3,2 < 3,2 > 3
;;test.asm:15
		defb 0,1,2,3
;;test.asm:16
		defb 0,1,2,3
;;test.asm:17
		defb (255),(255)
;;test.asm:18
		defb ((((+ value) >> 8) & 255)),((((( value - 256 )) >> 8) & 255))
;;test.asm:19
		defb (254),(254)
;;test.asm:20
		defb (((+ value) & 255)),(((( value - 1 )) & 255))
...

#------------------------------------------------------------------------------
# ASMPC
#------------------------------------------------------------------------------
t_asmpp_ok(<<'...', "-r0x1234", "\x12\x34\x12\x36");
		defb .high.$,.low.asmpc
		DEFB .HIGH.$,.LOW.ASMPC
...
t_text(scalar(read_file("test.i")), <<'...');
;;test.asm:1
AUTOLABEL_pc_1:
		defb (((( AUTOLABEL_pc_1 ) >> 8) & 255)) ,((( AUTOLABEL_pc_1 ) & 255))
;;test.asm:2
AUTOLABEL_pc_2:
		DEFB (((( AUTOLABEL_pc_2 ) >> 8) & 255)) ,((( AUTOLABEL_pc_2 ) & 255))
...

#------------------------------------------------------------------------------
# DEFL
#------------------------------------------------------------------------------
t_asmpp_ok(<<'...', "", "\1\2\3\3\0\4\0\5\0");
.val	defl val+1
		defb val
VAL:	DEFL VAL+1
		DEFB VAL
val		defl val+1
		defb val
val		defl $
		defw val
val		defl val+1
		defw val
val		defl val+1
		defw val
...
t_text(scalar(read_file("test.i")), <<'...');
;;test.asm:2
		defb 1
;;test.asm:4
		DEFB 2
;;test.asm:6
		defb 3
;;test.asm:7
AUTOLABEL_pc_1:
;;test.asm:8
		defw AUTOLABEL_pc_1
;;test.asm:10
		defw (AUTOLABEL_pc_1)+1
;;test.asm:12
		defw ((AUTOLABEL_pc_1)+1)+1
...

#------------------------------------------------------------------------------
# -D
#------------------------------------------------------------------------------
t_asmpp_ok(<<'...', "-Done -Dtwo=2 -Dthree=0x2+1", "\1\2\3\1\2\3");
		defb one,two,three
		DEFB one,two,three
...
t_text(scalar(read_file("test.i")), <<'...');
;;test.asm:1
		defb 1,2,3
;;test.asm:2
		DEFB 1,2,3
...
		
#------------------------------------------------------------------------------
# END
#------------------------------------------------------------------------------
t_asmpp_ok(<<'...', "", "\1\2\3\4");
		defb 1,2,3,4
		end
		defb 5,6,7,8
...
t_text(scalar(read_file("test.i")), <<'...');
;;test.asm:1
		defb 1,2,3,4
...

t_asmpp_ok(<<'...', "", "\1\2\3\4");
		defb 1,2,3,4
label:	end
		defb 5,6,7,8
...
t_text(scalar(read_file("test.i")), <<'...');
;;test.asm:1
		defb 1,2,3,4
...

t_asmpp_ok(<<'...', "", "\1\2\3\4");
start:	defb 1,2,3,4
label:	end start
		defb 5,6,7,8
...
t_text(scalar(read_file("test.i")), <<'...');
;;test.asm:1
start:	defb 1,2,3,4
...

#------------------------------------------------------------------------------
# DW, DEFW, DDB, DB, DEFB, DEFM, DATA, DS, DEFS, EQU
#------------------------------------------------------------------------------
t_asmpp_ok(<<'...', "", 
lbl1:	dw 0x1234
		DW 0x1234
lbl2:	defw 0x1234
		DEFW 0x1234
lbl3:	ddb 0x1234,0x4321
		DDB 0x1234,0x4321
lbl4:	db 1,2,3,4
		DB 1,2,3,4
lbl5:	defb 1,2,3,4
		DEFB 1,2,3,4
lbl6:	defm 1,2,3,4
		DEFM 1,2,3,4
lbl7:	data 1,2,3,4
		DATA 1,2,3,4
lbl8:	defs 4
		defb 1
		DEFS 4
		DEFB 1
lbl9:	ds 4
		db 1
		DS 4
		DB 1
one		equ 0+1
.two	EQU 1<<1
three:	EQU 10/3
		defb one,two,three
...
		"\x34\x12".
		"\x34\x12".
		"\x34\x12".
		"\x34\x12".
		"\x12\x34\x43\x21".
		"\x12\x34\x43\x21".
		"\1\2\3\4".
		"\1\2\3\4".
		"\1\2\3\4".
		"\1\2\3\4".
		"\1\2\3\4".
		"\1\2\3\4".
		"\1\2\3\4".
		"\1\2\3\4".
		"\0\0\0\0\1".
		"\0\0\0\0\1".
		"\0\0\0\0\1".
		"\0\0\0\0\1".
		"\1\2\3".
		"");
t_text(scalar(read_file("test.i")), <<'...');
;;test.asm:1
lbl1:	DEFW 4660
;;test.asm:2
		DEFW 4660
;;test.asm:3
lbl2:	defw 4660
;;test.asm:4
		DEFW 4660
;;test.asm:5
lbl3:	DEFB 18,52,67,33
;;test.asm:6
		DEFB 18,52,67,33
;;test.asm:7
lbl4:	DEFB 1,2,3,4
;;test.asm:8
		DEFB 1,2,3,4
;;test.asm:9
lbl5:	defb 1,2,3,4
;;test.asm:10
		DEFB 1,2,3,4
;;test.asm:11
lbl6:	DEFB 1,2,3,4
;;test.asm:12
		DEFB 1,2,3,4
;;test.asm:13
lbl7:	DEFB 1,2,3,4
;;test.asm:14
		DEFB 1,2,3,4
;;test.asm:15
lbl8:	defs 4
;;test.asm:16
		defb 1
;;test.asm:17
		DEFS 4
;;test.asm:18
		DEFB 1
;;test.asm:19
lbl9:	DEFS 4
;;test.asm:20
		DEFB 1
;;test.asm:21
		DEFS 4
;;test.asm:22
		DEFB 1
;;test.asm:23
	DEFC one = 1
;;test.asm:24
	DEFC two = 2
;;test.asm:25
	DEFC three = 3
;;test.asm:26
		defb one,two,three
...

#------------------------------------------------------------------------------
# --ucase
#------------------------------------------------------------------------------
t_asmpp_ok(<<'...', "", "\0");
		nop
...
t_text(scalar(read_file("test.i")), <<'...');
;;test.asm:1
		nop
...

t_asmpp_ok(<<'...', "--ucase", "\0");
		nop
...
t_text(scalar(read_file("test.i")), <<'...');
;;test.asm:1
		NOP
...

#------------------------------------------------------------------------------
# assemble Camel Forth 80
#------------------------------------------------------------------------------
my $cmd = "perl asmpp.pl --ucase -l -b -It/data CAMEL80.AZM";
ok 0 == system($cmd), $cmd;
t_binary(read_binfile("CAMEL80.bin"), 
		 read_binfile("t/data/CAMEL80.COM"));

unlink_testfiles(qw( CAMEL80.i CAMEL80.o CAMEL80.sym CAMEL80.lis CAMEL80.map CAMEL80.bin CAMEL80.reloc ));
done_testing();
exit 0;

#------------------------------------------------------------------------------
sub t_asmpp_ok {
	my($in, $args, $bin) = @_;
	ok 1,"[line ".((caller)[2])."]"." t_asmpp_ok";
	write_file("test.asm", $in);
	unlink("test.bin");
	my $cmd = "perl asmpp.pl -b $args test.asm";
	ok 0 == system($cmd), $cmd;
	t_binary(read_binfile("test.bin"), $bin);
}

#------------------------------------------------------------------------------
sub t_asmpp_error {
	my($in, $args, $error) = @_;
	ok 1,"[line ".((caller)[2])."]"." t_asmpp_error";
	write_file("test.asm", $in);
	my $cmd = "perl asmpp.pl -b $args test.asm";
	my($stdout, $stderr, $return) = capture {
		system $cmd;
	};
	ok $return != 0, "exit value";
	$stdout =~ s/^z80asm -b.*\s*//;
	eq_or_diff_text $stdout, "", "stdout";
	eq_or_diff_text $stderr, $error, "stderr";
}

#------------------------------------------------------------------------------
sub t_text {
	my($got, $expected) = @_;
	my $line = (caller)[2];
	for ($got, $expected) {
		s/^\s+/\t/;
		s/\s*$/\n/;
	}
	eq_or_diff_text $got, $expected, "[line ".$line."]";
}
