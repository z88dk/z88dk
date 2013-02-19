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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/listfile.t,v 1.1 2013-02-19 22:52:41 pauloscustodio Exp $
# $Log: listfile.t,v $
# Revision 1.1  2013-02-19 22:52:41  pauloscustodio
# BUG_0030 : List bytes patching overwrites header
# BUG_0031 : List file garbled with input lines with 255 chars
# New listfile.c with all the listing related code
#
#

use strict;
use warnings;
use File::Slurp;
use Test::More;
use Test::Differences; 
require 't/test_utils.pl';

# use after defined, local
list_push_asm("defc A = 1");
list_push_asm("defb A", 1);
list_push_asm("defw A", 1, 0);
list_push_asm("defl A", 1, 0, 0, 0);

# use before defined, global
list_push_asm("defb B", 2);
list_push_asm("defw B", 2, 0);
list_push_asm("defl B", 2, 0, 0, 0);
list_push_asm("defc B = 2");
list_push_asm("xdef B");

# create several pages of local and global referenced
for (0..255) {
	my $label = sprintf("%03d", $_);
	list_push_asm("xdef C$label");
	list_push_asm("C$label: defb $_", $_);
	list_push_asm("D$label: defb $_", $_);
}

# create a reference list with more than two lines in listing file
for (0 .. 18*3*61) {		# 18 references per line, 3 lines, 61 lines per page
	list_push_asm("defw E", 3, 0);
}
list_push_asm("defc E = 3");

# add labels of all sizes
for (1..255) {
	my $label = substr("X_".sprintf("%03d", $_).('_X' x $_), 0, $_);
			
	my $asm = "$label: defb $_";
	last if length($asm) >= get_max_line();
	
	list_push_asm($asm, $_);
}		

# list with more than 10000 lines - last test
while (get_num_lines() <= 10000) {
	list_push_asm("nop", 0);
}

list_test();

unlink_testfiles();
done_testing();
