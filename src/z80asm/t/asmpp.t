#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test asmpp.pl

#------------------------------------------------------------------------------
# simple code
#------------------------------------------------------------------------------
t_asmpp_ok(" nop", "", "\x00");

#------------------------------------------------------------------------------
# macros
#------------------------------------------------------------------------------
t_asmpp_error(<<END, "", <<END);
m1	macro
	nop
	endm
m1	macro
	nop
	endm
END
${test}.asm:4: error: macro multiply defined
END

t_asmpp_error(<<END, "", <<END);
m1	macro
	nop
END
${test}.asm:1: error: missing ENDM
END

for my $sep ("\t", ":", " :", ": ", " : ") {
	t_asmpp_ok("m1".$sep."macro\n nop\n endm\n m1", "", "\x00");
}

t_asmpp_error(<<END, "", <<END);
m1	macro
	nop
	endm
	
	m1 a
END
${test}.asm:5: error: extra macro arguments
END

t_asmpp_ok(<<END, "", "\xC5\xD5\xE5\xF5" x 5);
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
END

t_asmpp_ok(<<END, "", pack("C*", 1..6));
m1		macro #1,#2,#3	; comment
		defb #1,#2,#3	; comment
		endm			; comment
		
		m1 1 , 2 , 3  	; comment
		m1 4 , 5 , 6  	; comment
END

t_asmpp_ok(<<END, "", "endmhello");
m1		macro #str
		defm "endm" ; fake endm
		defm "#str"
		endm
		
		m1 "hello" ; unquote quoted args
END

t_asmpp_ok(<<END, "", "\xC3\x03\x00");
m1		macro
		jp next
next:
		endm
		
		m1
END

t_asmpp_error(<<END, "", <<END);
m1		macro
		jp next
next:
		endm
		
		m1
		m1
END
${test}.asm:7: error: duplicate definition: next
  ^---- next:
END

t_asmpp_ok(<<END, "", "\xC3\x03\x00\xC3\x06\x00");
m1		macro
		local #next
		jp #next
#next:
		endm
		
		m1
		m1
END

#------------------------------------------------------------------------------
# expressions
#------------------------------------------------------------------------------
t_asmpp_ok(<<END, "",
		defc value = 0x1234					; line 1
		defm "hello"						; line 2
		defb 32								; line 3
		defm 'world!'						; line 4
		defb 4ah,\$4b,#4c,&h4d,0x4e			; line 5
		DEFB 4AH,\$4B,#4C,&H4D,0X4E			; line 6
		defb 1b,%10,\@11,&b100,0b101		; line 7
		DEFB 1B,%10,\@11,&B100,0B101		; line 8
		defb 0.and.1,0.or.1,0.xor.0,.not.0	; line 9
		DEFB 0.AND.1,0.OR.1,0.XOR.0,.NOT.0	; line 10
		defb 1.shl.2,4.shr.2				; line 11
		DEFB 1.SHL.2,4.SHR.2				; line 12
		defb 2.equ.3,2.lt.3,2.gt.3			; line 13
		DEFB 2.EQU.3,2.LT.3,2.GT.3			; line 14
		defb \@'-',\@'#',\@"#-",\@"##"		; line 15
		defb %'-',%'#',%"#-",%"##"			; line 16
		defb .high. + 65534,.HIGH. ( 0xFF << 8 )	; line 17
		defb .high. + value,.HIGH. ( value - 256 )	; line 18
		defb .low. + 65534,.LOW. ( 0xFE00 >> 8 )	; line 19
		defb .low. + value,.LOW. ( value - 1 )		; line 20
END
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

check_text_file("${test}.i", <<END);
;;${test}.asm:1
		defc value = 4660
;;${test}.asm:2
		DEFB 104,101,108,108,111
;;${test}.asm:3
		defb 32
;;${test}.asm:4
		DEFB 119,111,114,108,100,33
;;${test}.asm:5
		defb 74,75,76,77,78
;;${test}.asm:6
		DEFB 74,75,76,77,78
;;${test}.asm:7
		defb 1,2,3,4,5
;;${test}.asm:8
		DEFB 1,2,3,4,5
;;${test}.asm:9
		defb 0 & 1,0 | 1,0 ^ 0, ! 0
;;${test}.asm:10
		DEFB 0 & 1,0 | 1,0 ^ 0, ! 0
;;${test}.asm:11
		defb 1 << 2,4 >> 2
;;${test}.asm:12
		DEFB 1 << 2,4 >> 2
;;${test}.asm:13
		defb 2 == 3,2 < 3,2 > 3
;;${test}.asm:14
		DEFB 2 == 3,2 < 3,2 > 3
;;${test}.asm:15
		defb 0,1,2,3
;;${test}.asm:16
		defb 0,1,2,3
;;${test}.asm:17
		defb (255),(255)
;;${test}.asm:18
		defb ((((+ value) >> 8) & 255)),((((( value - 256 )) >> 8) & 255))
;;${test}.asm:19
		defb (254),(254)
;;${test}.asm:20
		defb (((+ value) & 255)),(((( value - 1 )) & 255))
END

#------------------------------------------------------------------------------
# ASMPC
#------------------------------------------------------------------------------
t_asmpp_ok(<<END, "-r0x1234", "\x12\x34\x12\x36");
		defb .high.\$,.low.asmpc
		DEFB .HIGH.\$,.LOW.ASMPC
END

check_text_file("${test}.i", <<END);
;;${test}.asm:1
AUTOLABEL_pc_1:
		defb (((( AUTOLABEL_pc_1 ) >> 8) & 255)),((( AUTOLABEL_pc_1 ) & 255))
;;${test}.asm:2
AUTOLABEL_pc_2:
		DEFB (((( AUTOLABEL_pc_2 ) >> 8) & 255)),((( AUTOLABEL_pc_2 ) & 255))
END

#------------------------------------------------------------------------------
# DEFL
#------------------------------------------------------------------------------
t_asmpp_ok(<<END, "", "\1\2\3\3\0\4\0\5\0");
.val	defl val+1
		defb val
VAL:	DEFL VAL+1
		DEFB VAL
val		defl val+1
		defb val
val		defl \$
		defw val
val		defl val+1
		defw val
val		defl val+1
		defw val
END

check_text_file("${test}.i", <<END);
;;${test}.asm:2
		defb 1
;;${test}.asm:4
		DEFB 2
;;${test}.asm:6
		defb 3
;;${test}.asm:7
AUTOLABEL_pc_1:
;;${test}.asm:8
		defw AUTOLABEL_pc_1
;;${test}.asm:10
		defw (AUTOLABEL_pc_1)+1
;;${test}.asm:12
		defw ((AUTOLABEL_pc_1)+1)+1
END

#------------------------------------------------------------------------------
# -D
#------------------------------------------------------------------------------
t_asmpp_ok(<<END, "-Done -Dtwo=2 -Dthree=0x2+1", "\1\2\3\1\2\3");
		defb one,two,three
		DEFB one,two,three
END

check_text_file("${test}.i", <<END);
;;${test}.asm:1
		defb 1,2,3
;;${test}.asm:2
		DEFB 1,2,3
END
		
#------------------------------------------------------------------------------
# END
#------------------------------------------------------------------------------
t_asmpp_ok(<<END, "", "\1\2\3\4");
		defb 1,2,3,4
		end
		defb 5,6,7,8
END

check_text_file("${test}.i", <<END);
;;${test}.asm:1
		defb 1,2,3,4
END

t_asmpp_ok(<<END, "", "\1\2\3\4");
		defb 1,2,3,4
label:	end
		defb 5,6,7,8
END

check_text_file("${test}.i", <<END);
;;${test}.asm:1
		defb 1,2,3,4
END

t_asmpp_ok(<<END, "", "\1\2\3\4");
start:	defb 1,2,3,4
label:	end start
		defb 5,6,7,8
END

check_text_file("${test}.i", <<END);
;;${test}.asm:1
start:	defb 1,2,3,4
END

#------------------------------------------------------------------------------
# DW, DEFW, DDB, DB, DEFB, DEFM, DATA, DS, DEFS, EQU
#------------------------------------------------------------------------------
t_asmpp_ok(<<END, "", 
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
END
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

check_text_file("${test}.i", <<END);
;;${test}.asm:1
lbl1:	DEFW 4660
;;${test}.asm:2
		DEFW 4660
;;${test}.asm:3
lbl2:	defw 4660
;;${test}.asm:4
		DEFW 4660
;;${test}.asm:5
lbl3:	DEFB 18,52,67,33
;;${test}.asm:6
		DEFB 18,52,67,33
;;${test}.asm:7
lbl4:	DEFB 1,2,3,4
;;${test}.asm:8
		DEFB 1,2,3,4
;;${test}.asm:9
lbl5:	defb 1,2,3,4
;;${test}.asm:10
		DEFB 1,2,3,4
;;${test}.asm:11
lbl6:	DEFB 1,2,3,4
;;${test}.asm:12
		DEFB 1,2,3,4
;;${test}.asm:13
lbl7:	DEFB 1,2,3,4
;;${test}.asm:14
		DEFB 1,2,3,4
;;${test}.asm:15
lbl8:	defs 4
;;${test}.asm:16
		defb 1
;;${test}.asm:17
		DEFS 4
;;${test}.asm:18
		DEFB 1
;;${test}.asm:19
lbl9:	DEFS 4
;;${test}.asm:20
		DEFB 1
;;${test}.asm:21
		DEFS 4
;;${test}.asm:22
		DEFB 1
;;${test}.asm:23
	DEFC one = 1
;;${test}.asm:24
	DEFC two = 2
;;${test}.asm:25
	DEFC three = 3
;;${test}.asm:26
		defb one,two,three
END

#------------------------------------------------------------------------------
# --ucase
#------------------------------------------------------------------------------
t_asmpp_ok(<<END, "", "\0");
		nop
END

check_text_file("${test}.i", <<END);
;;${test}.asm:1
		nop
END

t_asmpp_ok(<<END, "--ucase", "\0");
		nop
END

check_text_file("${test}.i", <<END);
;;${test}.asm:1
		NOP
END

#------------------------------------------------------------------------------
# assemble Camel Forth 80
#------------------------------------------------------------------------------
run_ok("perl asmpp.pl --ucase -l -b -It/data CAMEL80.AZM");

check_bin_file("CAMEL80.bin", slurp("t/data/CAMEL80.COM"));

unlink_testfiles(qw( 
	CAMEL80.i CAMEL80.o CAMEL80.sym CAMEL80.lis CAMEL80.map 
	CAMEL80.bin CAMEL80.bin.hex 
	CAMEL80.exp CAMEL80.exp.hex 
	CAMEL80.reloc ));
done_testing;


#------------------------------------------------------------------------------
sub t_asmpp_ok {
	my($in, $args, $bin) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

	spew("${test}.asm", $in);
	unlink("${test}.bin");
	run_ok("perl asmpp.pl -b $args ${test}.asm");
	check_bin_file("${test}.bin", $bin);
}

#------------------------------------------------------------------------------
sub t_asmpp_error {
	my($in, $args, $error) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

	spew("${test}.asm", $in);
	run_nok("perl asmpp.pl -b $args ${test}.asm 2> ${test}.err");
	check_text_file("${test}.err", $error);
}
