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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/option-g.t,v 1.1 2011-07-11 15:46:33 pauloscustodio Exp $
# $Log: option-g.t,v $
# Revision 1.1  2011-07-11 15:46:33  pauloscustodio
# Added test scripts for all z80asm options
#
#
# Test option -g, -ng

use strict;
use warnings;
use File::Slurp;
use Test::More;
require 't/test_utils.pl';

my $asm = "xdef main \n main: ld b,10 \n loop: djnz loop";

# -g
t_z80asm_ok(0, $asm, "\x06\x0A\x10\xFE", "-g");
like read_file(def_file()),
	qr/ \A  \s*
		DEFC \s+ MAIN \s+ = \s+ \$0000; \s+ Module \s+ TEST \s+
	    \z /x;

# -ng
t_z80asm_ok(0, $asm, "\x06\x0A\x10\xFE", "-g -ng");
ok ! -f def_file();

unlink_testfiles();
done_testing();
