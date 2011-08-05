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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/op-INCLUDE.t,v 1.1 2011-08-05 19:28:40 pauloscustodio Exp $
# $Log: op-INCLUDE.t,v $
# Revision 1.1  2011-08-05 19:28:40  pauloscustodio
# Test include
#
#
# Test INCLUDE directive

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

unlink_testfiles();
write_file(asm_file(), 'include "'.inc_file().'"');
write_file(inc_file(), 'ld a,10');
t_z80asm_capture("-r0 -b ".asm_file(), "", "", 0);
t_binary(read_file(bin_file(), binary => ':raw'), "\x3E\x0A");

unlink_testfiles();
done_testing();
