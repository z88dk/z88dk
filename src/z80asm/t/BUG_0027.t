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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0027.t,v 1.3 2014-01-11 01:29:46 pauloscustodio Exp $
# $Log: BUG_0027.t,v $
# Revision 1.3  2014-01-11 01:29:46  pauloscustodio
# Extend copyright to 2014.
# Move CVS log to bottom of file.
#
# Revision 1.2  2013/02/19 22:52:40  pauloscustodio
# BUG_0030 : List bytes patching overwrites header
# BUG_0031 : List file garbled with input lines with 255 chars
# New listfile.c with all the listing related code
#
# Revision 1.1  2013/02/12 00:58:13  pauloscustodio
# BUG_0027 : Incorrect tabulation in symbol list
# BUG_0028 : Not aligned page list in symbol list with more that 18 references
# CH_0017 : Align with spaces, deprecate -t option
#
#
# BUG_0027 : Incorrect tabulation in symbol list

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

# add labels of all sizes
for (1..255) {
	my $label = substr("X_".sprintf("%03d", $_).('_X' x $_), 0, $_);
			
	my $asm = "$label: defb $_";
	last if length($asm) >= get_max_line();
	
	list_push_asm($asm, $_);
}		
list_test();	

unlink_testfiles();
done_testing();
