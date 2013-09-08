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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0034.t,v 1.2 2013-09-08 00:43:59 pauloscustodio Exp $
# $Log: BUG_0034.t,v $
# Revision 1.2  2013-09-08 00:43:59  pauloscustodio
# New error module with one error function per error, no need for the error
# constants. Allows compiler to type-check error message arguments.
# Included the errors module in the init() mechanism, no need to call
# error initialization from main(). Moved all error-testing scripts to
# one file errors.t.
#
# Revision 1.1  2013/05/06 23:02:12  pauloscustodio
# BUG_0034 : If assembly process fails with fatal error, invalid library is kept
# Option -x creates an empty library file (just the header). If the
# assembly process fails with a fatal errror afterwards, the library file
# is not deleted.
#
#
#
# BUG_0034 : If assembly process fails with fatal error, invalid library is kept

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

unlink_testfiles();

write_file(asm_file(), 'include "FILE_NOT_FOUND"');
t_z80asm_capture("-x".lib2_file()." ".asm_file(), "", 
				"Error at file 'test.asm' line 1: cannot read file 'FILE_NOT_FOUND'\n".
				"1 errors occurred during assembly\n", 1);
ok ! -f lib2_file(), lib2_file()." does not exist";

unlink_testfiles();
done_testing();
