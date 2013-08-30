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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/ERR_MAX_CODESIZE.t,v 1.5 2013-08-30 21:50:43 pauloscustodio Exp $
# $Log: ERR_MAX_CODESIZE.t,v $
# Revision 1.5  2013-08-30 21:50:43  pauloscustodio
# By suggestion of Philipp Klaus Krause: rename LEGACY to __LEGACY_Z80ASM_SYNTAX,
# as an identifier reserved by the C standard for implementation-defined behaviour
# starting with two underscores.
#
# Revision 1.4  2013/08/30 01:06:08  pauloscustodio
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
# Revision 1.3  2013/01/20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.2  2012/05/26 18:51:10  pauloscustodio
# CH_0012 : wrappers on OS calls to raise fatal error
# CH_0013 : new errors interface to decouple calling code from errors.c
#
# Revision 1.1  2012/05/23 18:07:51  pauloscustodio
# Unlink test files for errors from error numbers, to be able to change
# error numbers.
#
# Revision 1.4  2012/04/22 19:37:46  pauloscustodio
# Use read_binfile()
#
# Revision 1.3  2011/10/14 14:02:23  pauloscustodio
# test each of the MAXCODESIZE conditions in the code
#
# Revision 1.2  2011/07/14 01:32:09  pauloscustodio
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
# Test error 12

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

# test each of the MAXCODESIZE conditions in the code
my $COMMA = get_legacy() ? "&" : ",";

# DEFB
t_z80asm_ok(0, "defs 65535, 0xAA \n defb 0xAA \n",
	    "\xAA" x 65536);
t_z80asm_error("defs 65536, 0xAA \n defb 0xAA \n",
	       "Error at file 'test.asm' line 2: Max. code size of 65536 bytes reached");

t_z80asm_ok(0, "defs 65534, 0xAA \n defb 0xAA,0xAA \n",
	    "\xAA" x 65536);
t_z80asm_error("defs 65535, 0xAA \n defb 0xAA,0xAA \n",
	       "Error at file 'test.asm' line 2: Max. code size of 65536 bytes reached");

# DEFW
t_z80asm_ok(0, "defs 65534, 0xAA \n defw 0xAAAA \n",
	    "\xAA" x 65536);
t_z80asm_error("defs 65535, 0xAA \n defw 0xAAAA \n",
	       "Error at file 'test.asm' line 2: Max. code size of 65536 bytes reached");

t_z80asm_ok(0, "defs 65532, 0xAA \n defw 0xAAAA, 0xAAAA \n",
	    "\xAA" x 65536);
t_z80asm_error("defs 65533, 0xAA \n defw 0xAAAA, 0xAAAA \n",
	       "Error at file 'test.asm' line 2: Max. code size of 65536 bytes reached");

# DEFS
t_z80asm_ok(0, "defs 65536,0xAA", "\xAA" x 65536);
t_z80asm_error("defs 65537,0xAA", "Error at file 'test.asm' line 1: Max. code size of 65536 bytes reached");

# DEFP
t_z80asm_ok(0, "defs 65533, 0xAA \n defp 0xAAAA,0xAA \n",
	    "\xAA" x 65536);
t_z80asm_error("defs 65534, 0xAA \n defp 0xAAAA,0xAA \n",
	       "Error at file 'test.asm' line 2: Max. code size of 65536 bytes reached");

# DEFL
t_z80asm_ok(0, "defs 65532, 0xAA \n defl 0xAAAAAAAA \n",
	    "\xAA" x 65536);
t_z80asm_error("defs 65533, 0xAA \n defl 0xAAAAAAAA \n",
	       "Error at file 'test.asm' line 2: Max. code size of 65536 bytes reached");

# DEFM
t_z80asm_ok(0, "defs 65535, 'a' \n defm \"a\" \n",
	    "a" x 65536);
t_z80asm_error("defs 65536, 'a' \n defm \"a\" \n",
	       "Error at file 'test.asm' line 2: Max. code size of 65536 bytes reached");

t_z80asm_ok(0, "defs 65534, 'a' \n defm \"aa\" \n",
	    "a" x 65536);
t_z80asm_error("defs 65535, 'a' \n defm \"aa\" \n",
	       "Error at file 'test.asm' line 2: Max. code size of 65536 bytes reached");

t_z80asm_ok(0, "defs 65534, 'a' \n defm 97, \"a\" \n",
	    "a" x 65536);
t_z80asm_error("defs 65535, 'a' \n defm 97, \"a\" \n",
	       "Error at file 'test.asm' line 2: Max. code size of 65536 bytes reached");

t_z80asm_ok(0, "defs 65534, 'a' \n defm 97 $COMMA \"a\" \n",
	    "a" x 65536);
t_z80asm_error("defs 65535, 'a' \n defm 97 $COMMA \"a\" \n",
	       "Error at file 'test.asm' line 2: Max. code size of 65536 bytes reached");

t_z80asm_ok(0, "defs 65534, 'a' \n defm \"a\" $COMMA 97 \n",
	    "a" x 65536);
t_z80asm_error("defs 65535, 'a' \n defm \"a\" $COMMA 97 \n",
	       "Error at file 'test.asm' line 2: Max. code size of 65536 bytes reached");

# BINARY
my $bin_file = bin_file(); $bin_file =~ s/\.bin$/2.bin/i;
write_file($bin_file, {binmode => ':raw'}, "a" x 65536);
t_z80asm_ok(0, 'binary "'.$bin_file.'"',
	    "a" x 65536);

write_file($bin_file, {binmode => ':raw'}, "a" x 65537);
t_z80asm_error('binary "'.$bin_file.'"',
	       "Error at file 'test.asm' line 1: Max. code size of 65536 bytes reached");

# Linker
my $asm_file2 = asm_file(); $asm_file2 =~ s/\.asm$/2.asm/i;
my $file2_base = $asm_file2; $file2_base =~ s/\.asm$//i;
write_file($asm_file2, "defb 0xAA");

write_file(asm_file(), "defs 65535, 0xAA");
t_z80asm_capture("-r0 -b ".asm_file()." $asm_file2", "", "", 0);
t_binary(read_binfile(bin_file()),
	"\xAA" x 65536);

write_file(asm_file(), "defs 65536, 0xAA");
t_z80asm_capture("-r0 -b ".asm_file()." $asm_file2", "",
	"Error at module 'TEST2': Max. code size of 65536 bytes reached\n".
	"1 errors occurred during assembly\n", 1);

# parseline
t_z80asm_ok(0, "defs 65535, 0xAA \n defb 0xAA \n",
	    "\xAA" x 65536);
t_z80asm_error("defs 65536, 0xAA \n defb 0xAA \n",
	       "Error at file 'test.asm' line 2: Max. code size of 65536 bytes reached");

unlink_testfiles($bin_file, "$file2_base.asm", "$file2_base.obj", "$file2_base.sym");
done_testing();
