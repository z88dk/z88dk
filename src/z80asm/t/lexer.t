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
# Copyright (C) Paulo Custodio, 2011-2013

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/lexer.t,v 1.7 2013-09-08 00:43:59 pauloscustodio Exp $
# $Log: lexer.t,v $
# Revision 1.7  2013-09-08 00:43:59  pauloscustodio
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
#
# Test lexer

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

diag "Should accept binary constant longer than 8 bits";

my($COMMA, $AND, $XOR, $NOT,      $POWER) = get_legacy() ? 	
  ('&',    '~',  ':',  '0xFF :',  '^'   ) : 
  (',',    '&',  '^',  '~',       '**'  );
	
my @asmbin = (
	["ld a,1; comment ignored",		"\x3E\x01"],
	[".label_1 ld a,2",				"\x3E\x02"],
	["_label_2: ld a,3",			"\x3E\x03"],
	["defw label_1,_label_2",		"\x02\x00\x04\x00"],
	["defw #label_1",				"\x02\x00"],
	["defb 255,128D",				"\xFF\x80"],
	["defb \$FF,0xFE,0BEH",			"\xFF\xFE\xBE"],
	["defb \@1010,1010B",			"\x0A\x0A"],
	["defm \"hello\" $COMMA 32,\"world\"",
									"hello world"],
	["defb 1<0,1<1,1<2",			"\0\0\1"],
	["defb 1<=0,1<=1,1<=2",			"\0\1\1"],
	["defb 1=0,1=1,1=2",			"\0\1\0"],
	["defb 1<>0,1<>1,1<>2",			"\1\0\1"],
	["defb 1>0,1>1,1>2",			"\1\0\0"],
	["defb 1>=0,1>=1,1>=2",			"\1\1\0"],
	["defb +1,-1",					"\x01\xFF"],
	["defb 1+1,3-1,3 $AND 2,2|0,0 $XOR 2,( $NOT 0xAA ) $AND 0xFF",
									"\2\2\2\2\2\x55"],	# plus,minus,and,or,xor,not
	["defb 5*2,100/10,10%3",		"\x0A\x0A\x01"],
	["defb 2 $POWER 7, 2**6",		"\x80\x40"],
	["defb 2*[1+2*(1+2)]",			"\x0E"],
	["defb 2*1+2*1+2",				"\x06"],
	["defb !0,!1",					"\1\0"],
	["defb ' '",					"\x20"],
);
my($asm,$bin) = ("","");
for (@asmbin) {
	$asm .= $_->[0]."\n";
	$bin .= $_->[1];
}

t_z80asm_ok(0, $asm, $bin);

t_z80asm_error("defb ''",						"Error at file 'test.asm' line 1: syntax error in expression");
t_z80asm_error("defb 'he'",						"Error at file 'test.asm' line 1: syntax error in expression");

# test power expression (**) in object file
t_z80asm(
	asm		=> " xref v1, v2 : defb v1**v2",
	asm2	=> " xdef v1, v2 : defc v1 = 2, v2 = 7 ",
	bin		=> "\x80",
);

unlink_testfiles();
done_testing();
