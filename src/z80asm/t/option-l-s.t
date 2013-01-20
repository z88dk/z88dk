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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/option-l-s.t,v 1.2 2013-01-20 21:24:29 pauloscustodio Exp $
# $Log: option-l-s.t,v $
# Revision 1.2  2013-01-20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.1  2011/07/11 15:46:33  pauloscustodio
# Added test scripts for all z80asm options
#
#
# Test option -l, -nl, -s, -ns

use strict;
use warnings;
use File::Slurp;
use Test::More;
require 't/test_utils.pl';

my $asm = "
	xdef main
main:	ld b,10
loop:	djnz loop
	ret
";
my $re_header_sym = qr/ Z80 \s Module \s Assembler .* \s+ 
			Page \s+ 001 \s+ 'test.sym' \s+ /x;
my $re_header_lst = qr/ Z80 \s Module \s Assembler .* \s+ 
			Page \s+ 001 \s+ 'test.lst' \s+ /x;
my $re_list =	    qr/	1 \s+ 0000 \s+ 
			2 \s+ 0000 \s+ xdef \s main \s+ 
			3 \s+ 0000 \s+ 06 \s 0A \s+ main: \s+ ld \s b,10 \s+
			4 \s+ 0002 \s+ 10 \s FE \s+ loop: \s+ djnz \s loop \s+
			5 \s+ 0004 \s+ C9                 \s+ ret \s+
			6 \s+ 0005 \s+ /x;	
my $re_symbols =    qr/ Local \s Module \s Symbols: \s+
			LOOP \s+ = \s+ 00000002 \s+ (?: : \s+ 1\* \s+ )? 
			Global \s Module \s Symbols: \s+
			MAIN \s+ = \s+ 00000000 \s+ (?: : \s+ 1\* \s+ )? /x;

# no list file implies symbol table
unlink_testfiles();
write_file(asm_file(), $asm);
t_z80asm_capture(asm_file(), "", "", 0);
ok -f obj_file();
ok -f sym_file();
ok ! -f lst_file();
like read_file(sym_file()),
	qr/ \A 	$re_header_sym 
		$re_symbols
	    \z /x;

# no list file implies symbol table
unlink_testfiles();
write_file(asm_file(), $asm);
t_z80asm_capture("-nl ".asm_file(), "", "", 0);
ok -f obj_file();
ok -f sym_file();
ok ! -f lst_file();
like read_file(sym_file()),
	qr/ \A	$re_header_sym
		$re_symbols
	    \z /x;

# list file implies no symbol table
unlink_testfiles();
write_file(asm_file(), $asm);
t_z80asm_capture("-l ".asm_file(), "", "", 0);
ok -f obj_file();
ok ! -f sym_file();
ok -f lst_file();
like read_file(lst_file()),
	qr/ \A	$re_header_lst
		$re_list
		$re_symbols
	    \z /x;

# symbol table, no list
unlink_testfiles();
write_file(asm_file(), $asm);
t_z80asm_capture("-s ".asm_file(), "", "", 0);
ok -f obj_file();
ok -f sym_file();
ok ! -f lst_file();
like read_file(sym_file()),
	qr/ \A 	$re_header_sym 
		$re_symbols
	    \z /x;

# symbol table and list
unlink_testfiles();
write_file(asm_file(), $asm);
t_z80asm_capture("-l -s ".asm_file(), "", "", 0);
ok -f obj_file();
ok ! -f sym_file();
ok -f lst_file();
like read_file(lst_file()),
	qr/ \A 	$re_header_lst 
		$re_list
		$re_symbols
	    \z /x;

# symbol table, no list
unlink_testfiles();
write_file(asm_file(), $asm);
t_z80asm_capture("-nl -s ".asm_file(), "", "", 0);
ok -f obj_file();
ok -f sym_file();
ok ! -f lst_file();
like read_file(sym_file()),
	qr/ \A 	$re_header_sym 
		$re_symbols
	    \z /x;

# no symbol table, no list
unlink_testfiles();
write_file(asm_file(), $asm);
t_z80asm_capture("-nl -ns ".asm_file(), "", "", 0);
ok -f obj_file();
ok ! -f sym_file();
ok ! -f lst_file();


unlink_testfiles();
done_testing();
