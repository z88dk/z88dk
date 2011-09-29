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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0011.t,v 1.2 2011-09-29 21:29:08 pauloscustodio Exp $
#
# BUG_0011 : ASMPC should refer to start of statememnt, not current element in DEFB/DEFW
# Bug only happens with forward references in expressions

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

SKIP: {
    diag "This test should not fail, BUG in z80asm";
    skip "This test should not fail, BUG in z80asm", 1;

t_z80asm_ok(0x162D, <<'END',
L162D:  DEFB    'K', L1634-ASMPC-1  ; offset $06 to CHAN-K
        DEFB    'S', ' '
        DEFB    'P', ' '

        DEFB    $00             ; end marker.

L1634:

END
	"K\x06S P \x00");
}

unlink_testfiles();
done_testing();
