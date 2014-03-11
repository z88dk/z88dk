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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/expr.t,v 1.5 2014-03-11 00:15:13 pauloscustodio Exp $
#
# Test lexer and expressions

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

#------------------------------------------------------------------------------
# lexer
#------------------------------------------------------------------------------
unlink_testfiles();

diag "Should accept binary constant longer than 8 bits";

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
	["defb 255,128D",						"\xFF\x80"],
	["defb ZERO+255,ZERO+128D",				"\xFF\x80"],
	["defb \$FF,0xFE,0BEH,0ebh",			"\xFF\xFE\xBE\xEB"],
	["defb ZERO+\$FF,ZERO+0xFE,ZERO+0BEH,ZERO+0ebh",
											"\xFF\xFE\xBE\xEB"],
	["defb \@1010,1010B",					"\x0A\x0A"],
	["defb ZERO+\@1010,ZERO+1010B",			"\x0A\x0A"],
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
	asm		=> "XDEF ZERO : DEFC ZERO = 0",
	asm1	=> "XREF ZERO\n".$asm,
	bin		=> $bin
);

# test BUG_0006
t_z80asm_error("defb (2",		"Error at file 'test.asm' line 1: syntax error in expression");
t_z80asm_error("defb (2+[",		"Error at file 'test.asm' line 1: syntax error in expression");
t_z80asm_error("defb (2+[3-1]",	"Error at file 'test.asm' line 1: syntax error in expression");
t_z80asm_error("defb (2+[3-1)]","Error at file 'test.asm' line 1: syntax error in expression");

if ( ! get_legacy() ) {
	t_z80asm_error("defb 1?",		"Error at file 'test.asm' line 1: syntax error in expression");
	t_z80asm_error("defb 1?2",		"Error at file 'test.asm' line 1: syntax error in expression");
	t_z80asm_error("defb 1?2:",		"Error at file 'test.asm' line 1: syntax error in expression");
	t_z80asm_error("defb 1?2:1?",	"Error at file 'test.asm' line 1: syntax error in expression");
}

# text BUG_0043
t_z80asm(
	asm		=> "XDEF ZERO : DEFC ZERO = 0",
	asm1	=> "XREF ZERO : DEFB ZERO".("+0" x 122),	# line lenght = 255, expression len > 128
	bin		=> "\0",
);

#------------------------------------------------------------------------------
# calculator stack
#------------------------------------------------------------------------------
unlink_testfiles();
my $objs = "expr.o errors.o sym.o symtab.o symref.o ".
		   "options.o model.o hist.o ".
		   "lib/strutil.o lib/strhash.o lib/fileutil.o lib/srcfile.o ".
		   "lib/except.o ".
		   "lib/list.o lib/class.o";

my $init = <<'END';
struct module the_module;
struct module *CURRENTMODULE = &the_module;
struct modules the_modules;
struct modules *modulehdr = &the_modules;
char *CreateLibfile( char *filename ) {return NULL;}
char *GetLibfile( char *filename ) {return NULL;}
size_t get_PC( void ) { return 0; }
int list_get_page_nr() { return 1; }
void list_start_line( size_t address, char *source_file, int source_line_nr, char *line ) {}

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


# $Log: expr.t,v $
# Revision 1.5  2014-03-11 00:15:13  pauloscustodio
# Scanner reads input line-by-line instead of character-by-character.
# Factor house-keeping at each new line read in the scanner getasmline().
# Add interface to allow back-tacking of the recursive descent parser by
# getting the current input buffer position and comming back to the same later.
# SetTemporaryLine() keeps a stack of previous input lines.
# Scanner handles single-quoted strings and returns a number.
# New error for single-quoted string with length != 1.
# Scanner handles double-quoted strings and returns the quoted string.
#
# Revision 1.4  2014/03/06 00:18:43  pauloscustodio
# BUG_0043: buffer overflow on constants longer than 128 chars in object file
# z80asm crashed when the expression to be stored in the obejct file was
# longer than the maximum allocated size (128). Changed to dynamic string.
#
# Revision 1.3  2014/03/05 23:04:45  pauloscustodio
# hex constants in lower case
#
# Revision 1.2  2014/03/04 11:49:47  pauloscustodio
# Expression parser and expression evaluator use a look-up table of all
# supported unary, binary and ternary oprators, instead of a big switch
# statement to select the operation.
# Expression operations are stored in a contiguous array instead of
# a liked list to reduce administrative overhead of adding / iterating.
#
# Revision 1.1  2014/03/03 02:44:15  pauloscustodio
# Division by zero error was causing memory leaks - made non-fatal.
# Moved calculator stack to expr.c, made it singleton and based on array.h - no
# need to allocate on every expression computed, elements are stored in
# a vector instead of being allocated individually.
#
# Revision 1.11  2014/03/01 15:45:32  pauloscustodio
# CH_0021: New operators ==, !=, &&, ||, <<, >>, ?:
# Handle C-like operators, make exponentiation (**) right-associative.
# Simplify expression parser by handling composed tokens in lexer.
# Change token ids to TK_...
#
# Revision 1.10  2014/02/23 18:48:16  pauloscustodio
# CH_0021: New operators ==, !=, &&, ||, ?:
# Handle C-like operators ==, !=, &&, || and ?:.
# Simplify expression parser by handling composed tokens in lexer.
#
# Revision 1.9  2014/02/18 22:59:06  pauloscustodio
# BUG_0040: Detect and report division by zero instead of crashing
# BUG_0041: truncate negative powers to zero, i.e. pow(2,-1) == 0
#
# Revision 1.8  2014/01/11 01:29:46  pauloscustodio
# Extend copyright to 2014.
# Move CVS log to bottom of file.
#
# Revision 1.7  2013/09/08 00:43:59  pauloscustodio
# New error module with one error function per error, no need for the error
# constants. Allows compiler to type-check error message arguments.
# Included the errors module in the init() mechanism, no need to call
# error initialization from main(). Moved all error-testing scripts to
# one file errors.t.
#
# Revision 1.6  2013/08/30 21:50:43  pauloscustodio
# By suggestion of Philipp Klaus Krause: rename LEGACY to __LEGACY_Z80ASM_SYNTAX,
# as an identifier reserved by the C standard for implementation-defined behaviour
# starting with two underscores.
#
# Revision 1.5  2013/08/30 01:06:08  pauloscustodio
# New C-like expressions, defined when __LEGACY_Z80ASM_SYNTAX is not defined. Keeps old
# behaviour under -D__LEGACY_Z80ASM_SYNTAX (defined in legacy.h)
#
# BACKWARDS INCOMPATIBLE CHANGE, turned OFF by default (-D__LEGACY_Z80ASM_SYNTAX)
# - Expressions now use more standard C-like operators
# - Object and library files changed signature to
#   "Z80RMF02", "Z80LMF02", to avoid usage of old
#   object files with expressions inside in the old format
#
# Detail:
# - String concatenation in DEFM: changed from '&' to ',';  '&' will be AND
# - Power:                        changed from '^' to '**'; '^' will be XOR
# - XOR:                          changed from ':' to '^';
# - AND:                          changed from '~' to '&';  '~' will be NOT
# - NOT:                          '~' added as binary not
#
# Revision 1.4  2013/05/12 19:39:32  pauloscustodio
# warnings
#
# Revision 1.3  2013/01/20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.2  2012/05/22 20:33:34  pauloscustodio
# Added tests
#
# Revision 1.1  2012/05/20 06:32:50  pauloscustodio
# Added tests
#
# Revision 1.1  2011/08/05 19:28:40  pauloscustodio
# Test include
#

