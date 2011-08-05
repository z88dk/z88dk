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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/op-JR.t,v 1.1 2011-08-05 19:28:11 pauloscustodio Exp $
# $Log: op-JR.t,v $
# Revision 1.1  2011-08-05 19:28:11  pauloscustodio
# Test JR ranges
#
#
# Test JR offset computation directive

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

t_z80asm_ok(0, "label: \n".("nop\n" x 126)."jr label \n",
	       ("\0" x 126)."\x18\x80");
t_z80asm_ok(0, "label: \n".("nop\n" x 125)."jr label \n",
	       ("\0" x 125)."\x18\x81");
t_z80asm_ok(0, "label: \n".("nop\n" x 1)."jr label \n",
	       ("\0" x 1)."\x18\xFD");
t_z80asm_ok(0, "label: \n jr label \n",
	       "\x18\xFE");
t_z80asm_ok(0, "jr label \n label: \n",
	       "\x18\x00");
t_z80asm_ok(0, "jr label \n".("nop\n" x 1)." label: \n",
	       "\x18\x01".("\0" x 1));
t_z80asm_ok(0, "jr label \n".("nop\n" x 126)." label: \n",
	       "\x18\x7E".("\0" x 126));
t_z80asm_ok(0, "jr label \n".("nop\n" x 127)." label: \n",
	       "\x18\x7F".("\0" x 127));

unlink_testfiles();
done_testing();
