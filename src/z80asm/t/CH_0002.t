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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/CH_0002.t,v 1.7 2014-12-04 23:30:21 pauloscustodio Exp $
#
# Test correction of CH_0002, see hist.c for description

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

t_z80asm_ok(0, "ld a,    3",   "\x3E\x03");
t_z80asm_ok(0, "ld a,+ + 3",   "\x3E\x03");
t_z80asm_ok(0, "ld a,+ - 3",   "\x3E\xFD");

t_z80asm_ok(0, "ld a,-   3",   "\x3E\xFD");
t_z80asm_ok(0, "ld a,- + 3",   "\x3E\xFD");
t_z80asm_ok(0, "ld a,- - 3",   "\x3E\x03");

t_z80asm_ok(0, "inc (ix -  3)", "\xDD\x34\xFD");
t_z80asm_ok(0, "inc (ix - -3)", "\xDD\x34\x03");
t_z80asm_ok(0, "inc (ix - +3)", "\xDD\x34\xFD");

t_z80asm_ok(0, "inc (ix + 3)",  "\xDD\x34\x03");
t_z80asm_ok(0, "inc (ix + -3)", "\xDD\x34\xFD");
t_z80asm_ok(0, "inc (ix + +3)", "\xDD\x34\x03");

unlink_testfiles();
done_testing();
