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
# Copyright (C) Paulo Custodio, 2011

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/lexer.t,v 1.2 2012-05-22 20:33:34 pauloscustodio Exp $
# $Log: lexer.t,v $
# Revision 1.2  2012-05-22 20:33:34  pauloscustodio
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

diag "Should accept blanks between label and colon";
diag "Should accept binary constant longer than 8 bits";

my @asmbin = (
	['ld a,1; comment ignored',		"\x3E\x01"],
	['.label_1 ld a,2',				"\x3E\x02"],
	['_label_2: ld a,3',			"\x3E\x03"],
	['defw label_1,_label_2',		"\x02\x00\x04\x00"],
	['defw #label_1',				"\x02\x00"],
	['defb 255,128D',				"\xFF\x80"],
	['defb $FF,0xFE,0BEH',			"\xFF\xFE\xBE"],
	['defb @1010,1010B',			"\x0A\x0A"],
	['defm "hello"&32,"world"',		"hello world"],
	['defb 1<0,1<1,1<2',			"\0\0\1"],
	['defb 1<=0,1<=1,1<=2',			"\0\1\1"],
	['defb 1=0,1=1,1=2',			"\0\1\0"],
	['defb 1<>0,1<>1,1<>2',			"\1\0\1"],
	['defb 1>0,1>1,1>2',			"\1\0\0"],
	['defb 1>=0,1>=1,1>=2',			"\1\1\0"],
	['defb +1,-1',					"\x01\xFF"],
	['defb 1+1,3-1,3~2,2|0,0:2',	"\2\2\2\2\2"],	# plus,minus,and,or,xor
	['defb 5*2,100/10,10%3',		"\x0A\x0A\x01"],
	['defb 2^7',					"\x80"],
	['defb 2*[1+2*(1+2)]',			"\x0E"],
	['defb 2*1+2*1+2',				"\x06"],
	['defb !0,!1',					"\1\0"],
	["defb ' '",					"\x20"],
);
my($asm,$bin) = ("","");
for (@asmbin) {
	$asm .= $_->[0]."\n";
	$bin .= $_->[1];
}

t_z80asm_ok(0, $asm, $bin);

unlink_testfiles();
done_testing();
