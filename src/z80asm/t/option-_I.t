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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/option-_I.t,v 1.3 2012-05-23 20:45:42 pauloscustodio Exp $
# $Log: option-_I.t,v $
# Revision 1.3  2012-05-23 20:45:42  pauloscustodio
# Replace ERR_FILE_OPEN by ERR_FOPEN_READ and ERR_FOPEN_WRITE.
# Add tests.
#
# Revision 1.2  2011/07/14 01:32:09  pauloscustodio
#     - Unified "Integer out of range" and "Out of range" errors; they are the same error.
#     - Unified ReportIOError as ReportError(ERR_FILE_OPEN)
#     CH_0003 : Error messages should be more informative
#         - Added printf-args to error messages, added "Error:" prefix.
#     BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
#         - Raise ERR_UNBALANCED_PAREN instead
#
# Revision 1.1  2011/07/11 15:46:33  pauloscustodio
# Added test scripts for all z80asm options
#
#
# Test option -I

use strict;
use warnings;
use File::Slurp;
use File::Basename;
use Test::More;
require 't/test_utils.pl';

# create include file
my $inc = 't/data/'.basename(inc_file());
my $inc_base = basename($inc);
my $inc_dir  = dirname($inc);
write_file($inc, "ld a,1");

# no -I, full path : OK
t_z80asm_ok(0, "include \"$inc\"", "\x3E\x01");

# no -I, only file name : error
t_z80asm_error("include \"$inc_base\"", 
			"Error: File 'test.asm', at line 1, Cannot open file 'test.inc' for reading");

# -I : OK
t_z80asm_ok(0, "include \"$inc_base\"", "\x3E\x01", "-I$inc_dir");

unlink_testfiles($inc);
done_testing();
