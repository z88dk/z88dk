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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/expr.t,v 1.14 2014-07-06 23:43:21 pauloscustodio Exp $
#
# Test lexer and expressions

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

#------------------------------------------------------------------------------
# lexer
#------------------------------------------------------------------------------
unlink_testfiles();

my($COMMA, $AND, $XOR, $NOT,      $POWER) = get_legacy() ? 	
  ('&',    '~',  ':',  '0xFF :',  '^'   ) : 
  (',',    '&',  '^',  '~',       '**'  );
	
my @asmbin = (
	["ld a,1;comment",						"\x3E\x01"],
	[".label_1 ld a,2",						"\x3E\x02"],
	["_label_2: ld a,3",					"\x3E\x03"],
	["defw label_1,_label_2",				"\x02\x00\x04\x00"],
	["defw ZERO+label_1,ZERO+_label_2",		"\x02\x00\x04\x00"],
	["defw #label_1;comment",				"\x02\x00"],
	["defw #ZERO+label_1;comment",			"\x02\x00"],
	["defb 255,128",						"\xFF\x80"],
	["defb ZERO+255,ZERO+128",				"\xFF\x80"],
	["defb \$FF,0xFE,0BEH,0ebh",			"\xFF\xFE\xBE\xEB"],
	["defb ZERO+\$FF,ZERO+0xFE,ZERO+0BEH,ZERO+0ebh",
											"\xFF\xFE\xBE\xEB"],
	["defb \@1010,1010B",					"\x0A\x0A"],
	["defb ZERO+\@1010,ZERO+1010B",			"\x0A\x0A"],
	['defw @"####---###--##-#"',			"\xCD\xF1"],				# BUG_0044
	['defw @01111000111001101 ',			"\xCD\xF1"],				# BUG_0044
	['defl @"#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-"', "\xAA\xAA\xAA\xAA"],	# BUG_0044
	["defm \"hello\"${COMMA}32,\"\",\"world\"",			"hello world"],
	["defm \"hello\"${COMMA}ZERO+32,\"\",\"world\"",	"hello world"],
	["defb 1<0,1<1,1<2",					"\0\0\1"],
	["defb ZERO+1<0,ZERO+1<1,ZERO+1<2",		"\0\0\1"],
	["defb 1<=0,1<=1,1<=2",					"\0\1\1"],
	["defb ZERO+1<=0,ZERO+1<=1,ZERO+1<=2",	"\0\1\1"],
	["defb 1=0,1=1,1=2",					"\0\1\0"],
	["defb ZERO+1=0,ZERO+1=1,ZERO+1=2",		"\0\1\0"],
	["defb 1==0,1==1,1==2",					"\0\1\0"],		# CH_0021
	["defb ZERO+1==0,ZERO+1==1,ZERO+1==2",	"\0\1\0"],		# CH_0021
	["defb 1!=0,1!=1,1!=2",					"\1\0\1"],		# CH_0021
	["defb ZERO+1!=0,ZERO+1!=1,ZERO+1!=2",	"\1\0\1"],		# CH_0021
	["defb 1<>0,1<>1,1<>2",					"\1\0\1"],
	["defb ZERO+1<>0,ZERO+1<>1,ZERO+1<>2",	"\1\0\1"],
	["defb 1>0,1>1,1>2",					"\1\0\0"],
	["defb ZERO+1>0,ZERO+1>1,ZERO+1>2",		"\1\0\0"],
	["defb 1>=0,1>=1,1>=2",					"\1\1\0"],
	["defb ZERO+1>=0,ZERO+1>=1,ZERO+1>=2",	"\1\1\0"],
	["defb +1,-1",							"\x01\xFF"],
	["defb ZERO+ +1,ZERO+ -1",				"\x01\xFF"],
	["defb 1+1,3-1,3${AND}2,2|0,0${XOR}2,(${NOT}0xAA )${AND}0xFF",
											"\2\2\2\2\2\x55"],	# plus,minus,and,or,xor,not
	["defb ZERO+1+1,ZERO+3-1,ZERO+3${AND}2,ZERO+2|0,ZERO+0${XOR}2,ZERO+(${NOT}0xAA )${AND}0xFF",
											"\2\2\2\2\2\x55"],	# plus,minus,and,or,xor,not
	["defb 5*2,100/10,10%3",				"\x0A\x0A\x01"],
	["defb ZERO+5*2,ZERO+100/10,ZERO+10%3",	"\x0A\x0A\x01"],
	["defb 2${POWER}7, 2**6",				"\x80\x40"],
	["defb ZERO+2${POWER}7, 2**6",			"\x80\x40"],
	["defb 2${POWER}1",						"\x02"],
	["defb ZERO+2${POWER}1",				"\x02"],
	["defb 2${POWER}0",						"\x01"],
	["defb ZERO+2${POWER}0",				"\x01"],
	["defb 2${POWER}-1",					"\x00"],		# BUG_0041
	["defb ZERO+2${POWER}-1",				"\x00"],		# BUG_0041
	["defb 2*[1+2*(1+2)]",					"\x0E"],
	["defb ZERO+2*[1+2*(1+2)]",				"\x0E"],
	["defb 2*1+2*1+2",						"\x06"],
	["defb ZERO+2*1+2*1+2",					"\x06"],
	["defb !0,!1",							"\1\0"],
	["defb ZERO+!0,ZERO+!1",				"\1\0"],
	["defb 0&&0,0&&1,1&&0,1&&1",			"\0\0\0\1"],	# CH_0021
	["defb ZERO+0&&0,ZERO+0&&1,ZERO+1&&0,ZERO+1&&1",	
											"\0\0\0\1"],	# CH_0021
	["defb 0||0,0||1,1||0,1||1",			"\0\1\1\1"],	# CH_0021
	["defb ZERO+0||0,ZERO+0||1,ZERO+1||0,ZERO+1||1",
											"\0\1\1\1"],	# CH_0021
	["defb 0||0||1,0||0||0",				"\1\0"],		# CH_0021
	["defb ZERO+0||0||1,ZERO+0||0||0",		"\1\0"],		# CH_0021
	["defb ' '",							"\x20"],
	["defb ZERO+' '",						"\x20"],
	["defb 1<<7,128>>7",					"\x80\1"],		# CH_0021
	["defb ZERO+1<<7,ZERO+128>>7",			"\x80\1"],		# CH_0021
	
	# check priorities
	["defb 1 || 0 && 0",					"\1"],
	["defb 0 && 0 |  1",					"\0"],
	["defb 0 && 0${XOR}1",					"\0"],
	["defb 0 |  1${AND}1",					"\1"],
	["defb 1${XOR}0${AND}0",				"\1"],
	["defb 0${AND}1 == 0",					"\0"],
	["defb 0${AND}0 != 1",					"\0"],
	["defb 2 == 1 << 1",					"\1"],
	["defb 1 << 1 +  3",					"\x10"],
	["defb 1 +  2 *  3",					"\7"],
	["defb 2 *  3 ** 4",					pack("C",162)],
	["defw 2 ** 3 ** 2",					pack("v",512)],
	["defb 2 ** -3",						"\0"],
	["defb ---+--+-2",						"\2"],
	["EACH:DJNZ EACH",						"\x10\xFE"],	# CH_0021
	['defb @"--------"',					"\x00"],		# CH_0022
	['defb @"---##---"',					"\x18"],		# CH_0022
	['defb @"--#--#--"',					"\x24"],		# CH_0022
	['defb @"-#----#-"',					"\x42"],		# CH_0022
	['defb @"-######-"',					"\x7E"],		# CH_0022
	['defb @"-#----#-"',					"\x42"],		# CH_0022
	['defb @"-#----#-"',					"\x42"],		# CH_0022
	['defb @"--------"',					"\x00"],		# CH_0022
);

if ( ! get_legacy() ) {
	push @asmbin, 
	["defb 1?2:3,0?4:5",			"\2\5"],		# CH_0021
	["defb ZERO+1?2:3,0?4:5",		"\2\5"],		# CH_0021
	["defb 0? 0?2:3 :0?4:5",		"\5"],			# CH_0021
	["defb ZERO+0? 0?2:3 :0?4:5",	"\5"],			# CH_0021
	["defb 0? 0?2:3 :1?4:5",		"\4"],			# CH_0021
	["defb ZERO+0? 0?2:3 :1?4:5",	"\4"],			# CH_0021
	["defb 1? 0?2:3 :1?4:5",		"\3"],			# CH_0021
	["defb ZERO+1? 0?2:3 :1?4:5",	"\3"],			# CH_0021
	["defb 1? 1?2:3 :1?4:5",		"\2"],			# CH_0021
	["defb ZERO+1? 1?2:3 :1?4:5",	"\2"],			# CH_0021
	["defb ~~2",					"\2"],
}

my($asm,$bin) = ("","");
for (@asmbin) {
	$asm .= $_->[0]."\n";
	$bin .= $_->[1];
}

t_z80asm(
	asm		=> "PUBLIC ZERO : DEFC ZERO = 0",
	asm1	=> "EXTERN ZERO\n".$asm,
	bin		=> $bin
);

if ( ! get_legacy() ) {
	t_z80asm_error("defb 1?",		"Error at file 'test.asm' line 1: syntax error in expression");
	t_z80asm_error("defb 1?2",		"Error at file 'test.asm' line 1: syntax error in expression");
	t_z80asm_error("defb 1?2:",		"Error at file 'test.asm' line 1: syntax error in expression");
	t_z80asm_error("defb 1?2:1?",	"Error at file 'test.asm' line 1: syntax error in expression");
}

# text BUG_0043
t_z80asm(
	asm		=> "PUBLIC ZERO : DEFC ZERO = 0",
	asm1	=> "EXTERN ZERO : DEFB ZERO".("+0" x 122),	# line lenght = 255, expression len > 128
	bin		=> "\0",
);

#------------------------------------------------------------------------------
# calculator stack
#------------------------------------------------------------------------------
unlink_testfiles();
my $objs = "expr.o errors.o sym.o symtab.o symref.o ".
		   "options.o model.o module.o hist.o codearea.o scan.o listfile.o ".
		   "lib/strutil.o lib/strhash.o lib/fileutil.o lib/srcfile.o ".
		   "lib/except.o ".
		   "lib/list.o lib/array.o lib/class.o";

my $init = <<'END';
#include "symbol.h"

char *GetLibfile( char *filename ) {return NULL;}

long add3(long a, long b, long c) { return 3+a+b+c; }
long add2(long a, long b) { return 2+a+b; }
long add1(long a) { return 1+a; }
END

t_compile_module($init, <<'END', $objs);
	Calc_push(23); 
	Calc_compute_unary(add1);
	assert( Calc_pop() == 24 );
	
	Calc_push(11);
	Calc_push(22);
	Calc_compute_binary(add2);
	assert( Calc_pop() == 35 );
	
	Calc_push(11);
	Calc_push(22);
	Calc_push(33);
	Calc_compute_ternary(add3);
	assert( Calc_pop() == 69 );
	
END

t_run_module([], '', '', 0);


unlink_testfiles();
done_testing();
