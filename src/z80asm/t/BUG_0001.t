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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0001.t,v 1.8 2014-04-13 20:32:10 pauloscustodio Exp $
# $Log: BUG_0001.t,v $
# Revision 1.8  2014-04-13 20:32:10  pauloscustodio
# PUBLIC and EXTERN instead of LIB, XREF, XDEF, XLIB
#
# Revision 1.7  2014/01/11 01:29:45  pauloscustodio
# Extend copyright to 2014.
# Move CVS log to bottom of file.
#
# Revision 1.6  2013/02/12 00:55:00  pauloscustodio
# CH_0017 : Align with spaces, deprecate -t option
#
# Revision 1.5  2013/01/20 21:24:28  pauloscustodio
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

my $asm = "
JP NN
JP NN
NN:
";

my $bin = "\xC3\x06\x00\xC3\x06\x00";

t_z80asm(
	asm		=> $asm,
	bin		=> $bin,
);

# Test bugfix of BUG_0001(a)
t_z80asm(
	asm		=> " EXTERN value : ld a,value-0 ",
	asm2	=> " PUBLIC value : defc value=10 ",
	bin		=> "\x3E\x0A",
);

unlink_testfiles();
done_testing();
