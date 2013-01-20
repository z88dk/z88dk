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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0025.t,v 1.1 2013-01-20 12:50:05 pauloscustodio Exp $
# $Log: BUG_0025.t,v $
# Revision 1.1  2013-01-20 12:50:05  pauloscustodio
# BUG_0025 : JR at org 0 with out-of-range jump crashes WriteListFile()
# jr instruction on address 0, with out of range argument ->
# jr calls error and writes incomplete opcode (only one byte);
# WriteListFile tries to list bytes from -1 to 1 -> crash
#
#
# BUG_0025 : JR at org 0 with out-of-range jump crashes WriteListFile()

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

# JR / DJNZ
for my $jump (qw( jr djnz ))
{
	t_z80asm(
		asm		=> "$jump asmpc+2-129",
		err		=> "Error at file 'test.asm' line 1: Integer '-129' out of range",
	);

	t_z80asm(
		asm		=> "$jump asmpc+2+128",
		err		=> "Error at file 'test.asm' line 1: Integer '128' out of range",
	);
}

unlink_testfiles();
done_testing();
