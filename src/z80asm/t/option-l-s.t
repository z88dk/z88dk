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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/option-l-s.t,v 1.7 2013-02-19 22:52:40 pauloscustodio Exp $
# $Log: option-l-s.t,v $
# Revision 1.7  2013-02-19 22:52:40  pauloscustodio
# BUG_0030 : List bytes patching overwrites header
# BUG_0031 : List file garbled with input lines with 255 chars
# New listfile.c with all the listing related code
#
# Revision 1.6  2013/02/16 09:46:56  pauloscustodio
# BUG_0029 : Incorrect alignment in list file with more than 4 bytes opcode
#
# Revision 1.5  2013/02/12 00:58:13  pauloscustodio
# BUG_0027 : Incorrect tabulation in symbol list
# BUG_0028 : Not aligned page list in symbol list with more that 18 references
# CH_0017 : Align with spaces, deprecate -t option
#
# Revision 1.4  2013/02/11 21:54:38  pauloscustodio
# BUG_0026 : Incorrect paging in symbol list
#
# Revision 1.3  2013/01/24 23:03:03  pauloscustodio
# Replaced (unsigned char) by (byte_t)
# Replaced (unisigned int) by (size_t)
# Replaced (short) by (int)
#
# Revision 1.2  2013/01/20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.1  2011/07/11 15:46:33  pauloscustodio
# Added test scripts for all z80asm options
#
#
# Test option -l, -nl, -s, -ns

use strict;
use warnings;
use File::Slurp;
use Test::More;
require 't/test_utils.pl';

my $asm = "
	xdef main
main:	ld b,10
loop:	djnz loop
	ret
";
my $bin = pack("C*", 
	0x06, 10,
	0x10, -2 & 0xFF,
	0xC9
);

# no symbol table, no list
t_z80asm(
	asm		=> $asm,
	bin		=> $bin,
	options	=> '-nl -ns',
	nolist	=> 1,
);

# list file implies no symbol table
for my $option ('-l', '-l -s') {
	t_z80asm(
		asm		=> $asm,
		bin		=> $bin,
		options	=> $option,
		nolist	=> 1,
	);
}

# no list file implies symbol table
for my $option ('', '-nl', '-s', '-nl -s') {
	t_z80asm(
		asm		=> $asm,
		bin		=> $bin,
		options	=> $option,
		nolist	=> 1,
	);
}

unlink_testfiles();
done_testing();
