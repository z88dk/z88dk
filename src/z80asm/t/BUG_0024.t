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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0024.t,v 1.2 2013-01-20 21:24:28 pauloscustodio Exp $
# $Log: BUG_0024.t,v $
# Revision 1.2  2013-01-20 21:24:28  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.1  2013/01/20 13:18:10  pauloscustodio
# BUG_0024 : (ix+128) should show warning message
# Signed integer range was wrongly checked to -128..255 instead
# of -128..127
#
#
# BUG_0024 : (ix+255) should show warning message but is assembled as (ix-1)

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

# Integer out of range
ok 1, "Tested by ERR_INT_RANGE.t";

unlink_testfiles();
done_testing();
