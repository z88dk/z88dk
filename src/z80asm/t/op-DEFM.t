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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/op-DEFM.t,v 1.4 2014-01-11 01:29:46 pauloscustodio Exp $
# $Log: op-DEFM.t,v $
# Revision 1.4  2014-01-11 01:29:46  pauloscustodio
# Extend copyright to 2014.
# Move CVS log to bottom of file.
#
# Revision 1.3  2013/09/08 00:43:59  pauloscustodio
# New error module with one error function per error, no need for the error
# constants. Allows compiler to type-check error message arguments.
# Included the errors module in the init() mechanism, no need to call
# error initialization from main(). Moved all error-testing scripts to
# one file errors.t.
#
# Revision 1.2  2013/08/30 21:50:43  pauloscustodio
# By suggestion of Philipp Klaus Krause: rename LEGACY to __LEGACY_Z80ASM_SYNTAX,
# as an identifier reserved by the C standard for implementation-defined behaviour
# starting with two underscores.
#
# Revision 1.1  2013/08/30 01:06:08  pauloscustodio
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
