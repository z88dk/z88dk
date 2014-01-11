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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0020.t,v 1.4 2014-01-11 01:29:46 pauloscustodio Exp $
# $Log: BUG_0020.t,v $
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
# Revision 1.2  2013/01/20 21:24:28  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.1  2012/06/05 22:24:47  pauloscustodio
# BUG_0020 : Segmentation fault in ParseIdent for symbol not found with interpret OFF
#
#
# BUG_0020 : Segmentation fault in ParseIdent for symbol not found with interpret OFF

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

write_file(asm_file(), "
	IF C
	invalid
	ENDIF
");
t_z80asm_capture("-r0 -b -DC ".asm_file(), "", 
	"Error at file 'test.asm' line 3: unknown identifier\n".
	"1 errors occurred during assembly\n", 1);

t_z80asm_capture("-r0 -b ".asm_file(), "", "", 0);
t_binary(read_binfile(bin_file()), "");

unlink_testfiles();
done_testing();
