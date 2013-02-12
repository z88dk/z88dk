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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0027.t,v 1.1 2013-02-12 00:58:13 pauloscustodio Exp $
# $Log: BUG_0027.t,v $
# Revision 1.1  2013-02-12 00:58:13  pauloscustodio
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

# Integer out of range
ok 1, "Tested by option-l-s.t";

unlink_testfiles();
done_testing();
