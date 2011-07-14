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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/option-forcexlib.t,v 1.2 2011-07-14 01:32:09 pauloscustodio Exp $
# $Log: option-forcexlib.t,v $
# Revision 1.2  2011-07-14 01:32:09  pauloscustodio
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
# Test option -forcexlib

use strict;
use warnings;
use File::Slurp;
use Test::More;
require 't/test_utils.pl';

my $lib = lib_file(); $lib =~ s/\.lib$/2.lib/i;

# OK case
unlink_testfiles();
write_file(asm_file(), "xlib main \n main: ret");
t_z80asm_capture("-x".$lib." ".asm_file(), "", "", 0);
ok -f $lib;
t_z80asm_ok(0, "lib main \n call main", 
		"\xCD\x03\x00\xC9",
		"-i".$lib);

# no XLIB - error
unlink_testfiles($lib);
write_file(asm_file(), "module main \n main: ret");
t_z80asm_capture("-x".$lib." ".asm_file(), "", "", 0);
ok -f $lib;
write_file(asm_file(), "lib main \n call main");
t_z80asm_capture("-r0 -b -i".$lib." ".asm_file(), "",
		"Error: File 'test.asm', Module 'TEST', Symbol not defined\n".
		"1 errors occurred during assembly\n", 
		1);

# -forcexlib - OK
unlink_testfiles($lib);
write_file(asm_file(), "module main \n main: ret");
t_z80asm_capture("-forcexlib -x".$lib." ".asm_file(), "", "", 0);
ok -f $lib;
t_z80asm_ok(0, "lib main \n call main", 
		"\xCD\x03\x00\xC9",
		"-i".$lib);

unlink_testfiles($lib);
done_testing();
