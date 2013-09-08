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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0023.t,v 1.3 2013-09-08 00:43:59 pauloscustodio Exp $
# $Log: BUG_0023.t,v $
# Revision 1.3  2013-09-08 00:43:59  pauloscustodio
# New error module with one error function per error, no need for the error
# constants. Allows compiler to type-check error message arguments.
# Included the errors module in the init() mechanism, no need to call
# error initialization from main(). Moved all error-testing scripts to
# one file errors.t.
#
# Revision 1.2  2013/01/20 21:24:28  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.1  2013/01/19 23:54:04  pauloscustodio
# BUG_0023 : Error file with warning is removed in link phase
# z80asm -b f1.asm
# If assembling f1.asm produces a warning, the link phase removes the f1.err
# file hidding the warning.
#
#
# BUG_0023 : Error file with warning is removed in link phase

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

t_z80asm(
	asm		=> "ld a,-129",
	bin		=> "\x3E\x7F",
	err		=> "Warning at file 'test.asm' line 1: integer '-129' out of range",
);

t_z80asm(
	asm  	=> "xref value : ld a,value : ld b,256",
	asm1	=> "xdef value : defc value = -129",
	bin		=> "\x3E\x7F\x06\x00",
	err		=> "Warning at file 'test.asm' line 3: integer '256' out of range\n".
			   "Warning at file 'test.asm' module 'TEST': integer '-129' out of range in expression 'VALUE'",
);


unlink_testfiles();
done_testing();
