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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0026.t,v 1.3 2013-02-19 22:52:40 pauloscustodio Exp $
# $Log: BUG_0026.t,v $
# Revision 1.3  2013-02-19 22:52:40  pauloscustodio
# BUG_0030 : List bytes patching overwrites header
# BUG_0031 : List file garbled with input lines with 255 chars
# New listfile.c with all the listing related code
#
# Revision 1.2  2013/02/12 00:55:32  pauloscustodio
# Comment
#
# Revision 1.1  2013/02/11 21:54:38  pauloscustodio
# BUG_0026 : Incorrect paging in symbol list
#

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

for (0 .. 255) {
	list_push_asm("XDEF GLOBAL$_");
	list_push_asm("GLOBAL$_: defb $_", $_);
	list_push_asm("LOCAL$_: defb $_", $_);
}
list_test();	

unlink_testfiles();
done_testing();
