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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/option-m.t,v 1.3 2013-02-12 00:55:00 pauloscustodio Exp $
# $Log: option-m.t,v $
# Revision 1.3  2013-02-12 00:55:00  pauloscustodio
# CH_0017 : Align with spaces, deprecate -t option
#
# Revision 1.2  2013/01/20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.1  2011/07/11 15:46:33  pauloscustodio
# Added test scripts for all z80asm options
#
#
# Test option -m, -nm

use strict;
use warnings;
use File::Slurp;
use Test::More;
use Test::Differences; 
require 't/test_utils.pl';

my $asm = "
	xdef main
main: ld b,10
loop: djnz loop
x31_x31_x31_x31_x31_x31_x31_x31: defb 0
x_32_x32_x32_x32_x32_x32_x32_x32: defb 0
";
my $asm2 = "
	xdef func
func: ret
";
my $bin = "\x06\x0A\x10\xFE\x00\x00\xC9";


# -m
t_z80asm(
	asm		=> $asm,
	asm2	=> $asm2,
	bin		=> $bin,
	options	=> '-m',
);
ok -f map_file(), map_file();
eq_or_diff scalar(read_file(map_file())), <<'END', "mapfile contents";
FUNC                            = 0006, G: TEST2
LOOP                            = 0002, L: TEST
MAIN                            = 0000, G: TEST
X31_X31_X31_X31_X31_X31_X31_X31 = 0004, L: TEST
X_32_X32_X32_X32_X32_X32_X32_X32 = 0005, L: TEST


MAIN                            = 0000, G: TEST
LOOP                            = 0002, L: TEST
X31_X31_X31_X31_X31_X31_X31_X31 = 0004, L: TEST
X_32_X32_X32_X32_X32_X32_X32_X32 = 0005, L: TEST
FUNC                            = 0006, G: TEST2
END


# -nm
t_z80asm(
	asm		=> $asm,
	asm2	=> $asm2,
	bin		=> $bin,
	options	=> '-m -nm',
);
ok ! -f map_file(), "no ".map_file();


unlink_testfiles();
done_testing();
