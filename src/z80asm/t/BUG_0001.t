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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0001.t,v 1.5 2013-01-20 21:24:28 pauloscustodio Exp $
# $Log: BUG_0001.t,v $
# Revision 1.5  2013-01-20 21:24:28  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.4  2011/07/14 23:49:50  pauloscustodio
#     BUG_0001(a) : during correction of BUG_0001, new symbol colon was introduced in enum symbols,
# 	causing expressions stored in object files to be wrong, e.g. VALUE-1 was stored as
# 	VALUE*1. This caused problems in expression evaluation in link phase.
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
# Test correction of BUG_0001, see hist.c for description

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

my $ASM = "
JP NN
JP NN
NN:
";
my $BIN = "\xC3\x06\x00\xC3\x06\x00";
t_z80asm_ok(0, $ASM, $BIN, "-t4 -b");

# Test bugfix of BUG_0001(a)
my $asm2 = asm_file(); $asm2 =~ s/\.asm$/2.asm/i;
write_file(asm_file(), "
	xref value
	ld a,value-0
");
write_file($asm2, "
	xdef value
	defc value=10
");
t_z80asm_capture("-r0 -b ".asm_file()." ".$asm2, "", "", 0);
t_binary(read_file(bin_file(), binary => ':raw'), "\x3E\x0A");

unlink_testfiles($asm2);
done_testing();
