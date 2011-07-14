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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0005.t,v 1.4 2011-07-14 01:32:09 pauloscustodio Exp $
# $Log: BUG_0005.t,v $
# Revision 1.4  2011-07-14 01:32:09  pauloscustodio
#     - Unified "Integer out of range" and "Out of range" errors; they are the same error.
#     - Unified ReportIOError as ReportError(ERR_FILE_OPEN)
#     CH_0003 : Error messages should be more informative
#         - Added printf-args to error messages, added "Error:" prefix.
#     BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
#         - Raise ERR_UNBALANCED_PAREN instead
#
# Revision 1.3  2011/07/09 18:25:35  pauloscustodio
# Log keyword in checkin comment was expanded inside Log expansion... recursive
# Added Z80asm banner to all source files
#
# Revision 1.2  2011/07/09 17:36:09  pauloscustodio
# Copied cvs log into Log history
#
# Revision 1.1  2011/07/09 01:02:45  pauloscustodio
# Started to build test suite in t/ *.t unsing Perl prove. Included test for all standard
# Z80 opcodes; need to be extended with directives and opcodes for Z80 variants.
#
# Test correction of BUG_0005, see hist.c for description

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

# OK:    (ix), (ix+3), (ix-3)
# ERROR: (ix 4)
t_z80asm_ok(0, "inc (ix)",      "\xDD\x34\x00");
t_z80asm_ok(0, "inc (ix + 3)",  "\xDD\x34\x03");
t_z80asm_ok(0, "inc (ix - 3)",  "\xDD\x34\xFD");
t_z80asm_error("inc (ix   3)", 	"Error: File 'test.asm', at line 1, Syntax error");

unlink_testfiles();
done_testing();
