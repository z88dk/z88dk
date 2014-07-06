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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/op-DEFM.t,v 1.5 2014-07-06 23:43:21 pauloscustodio Exp $

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

my $COMMA = get_legacy() ? "&" : ",";

t_z80asm_ok(0, 'defm "hello"',				"hello");
t_z80asm_ok(0, 'defm "hello";test',			"hello");

# comma works both in legacy and in new
t_z80asm_ok(0, 'defm "hello",32,"world"',	"hello world");

t_z80asm_ok(0, "defm \"hello\" $COMMA 32 $COMMA \"world\"",	
											"hello world");
t_z80asm_ok(0, "defm 32 $COMMA \"world\"",	" world");
t_z80asm_ok(0, "defm \"hello\" $COMMA 32",	"hello ");
t_z80asm_ok(0, 'defm 32',					" ");

t_z80asm_error('defm "hello"&',				"Error at file 'test.asm' line 1: syntax error".
											($COMMA eq '&' ? " in expression" : ""));
t_z80asm_error('defm "hello",',				"Error at file 'test.asm' line 1: syntax error in expression");

if ($COMMA eq ',') {
	t_z80asm_error('defm "hello"&32&"world"', "Error at file 'test.asm' line 1: syntax error");
}

unlink_testfiles();
done_testing();
