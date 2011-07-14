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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/error-30.t,v 1.2 2011-07-14 01:32:09 pauloscustodio Exp $
# $Log: error-30.t,v $
# Revision 1.2  2011-07-14 01:32:09  pauloscustodio
#     - Unified "Integer out of range" and "Out of range" errors; they are the same error.
#     - Unified ReportIOError as ReportError(ERR_FILE_OPEN)
#     CH_0003 : Error messages should be more informative
#         - Added printf-args to error messages, added "Error:" prefix.
#     BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
#         - Raise ERR_UNBALANCED_PAREN instead
#
# Revision 1.1  2011/07/12 22:47:59  pauloscustodio
# - Moved all error variables and error reporting code to a separate module errors.c,
#   replaced all extern declarations of these variables by include errors.h,
#   created symbolic constants for error codes.
# - Added test scripts for error messages.
#
#
#
# Test error 30

use strict;
use warnings;
use File::Copy;
use Test::More;
require 't/test_utils.pl';

# create a lib name that is not removed by unlink_testfiles()
my $lib = lib_file(); $lib =~ s/\.lib$/lib.lib/i;
unlink_testfiles($lib);

# create a library without Z80_STDLIB
delete $ENV{Z80_STDLIB};
write_file(asm_file(), "
	xlib one
one: 
	ld a,1
	ret
");
t_z80asm_capture("-x".lib_file()." ".asm_file(), "", "", 0);
ok -f obj_file(), obj_file()." created";
ok -f lib_file(), lib_file()." created";

# save for later
ok copy(lib_file(), $lib), "create $lib";

is unlink(obj_file(), lib_file()), 2, "delete old obj and lib";

# ERR_NO_ENVVAR => 30
delete $ENV{Z80_STDLIB};
t_z80asm_capture("-x ".asm_file(), "", 
		"Error: Environment variable 'Z80_STDLIB' not defined\n".
		"1 errors occurred during assembly\n", "stderr",
		1);

# create the same library with Z80_STDLIB
$ENV{Z80_STDLIB} = lib_file();
t_z80asm_capture("-x ".asm_file(), "", "", 0);
ok -f obj_file(), obj_file()." created";
ok -f lib_file(), lib_file()." created";

# link with the library without Z80_STDLIB
delete $ENV{Z80_STDLIB};
t_z80asm_ok(0, "
	lib one
	jp one
", "\xC3\x03\x00\x3E\x01\xC9", "-i$lib");

# link with the library with Z80_STDLIB
$ENV{Z80_STDLIB} = $lib;
t_z80asm_ok(0, "
	lib one
	jp one
", "\xC3\x03\x00\x3E\x01\xC9", "-i");

# ERR_NO_ENVVAR => 30
delete $ENV{Z80_STDLIB};
t_z80asm_capture("-x ".asm_file(), "", 
		"Error: Environment variable 'Z80_STDLIB' not defined\n".
		"1 errors occurred during assembly\n", "stderr",
		1);

unlink_testfiles($lib);
done_testing();
