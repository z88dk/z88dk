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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/option-b.t,v 1.2 2013-01-20 21:24:29 pauloscustodio Exp $
# $Log: option-b.t,v $
# Revision 1.2  2013-01-20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.1  2011/07/11 15:46:33  pauloscustodio
# Added test scripts for all z80asm options
#
#
# Test option -b, -nb

use strict;
use warnings;
use File::Slurp;
use Test::More;
require 't/test_utils.pl';

# -b
unlink_testfiles();
write_file(asm_file(), "nop");

t_z80asm_capture("-r0 -b ".asm_file(), "", "", 0);
ok -f obj_file();
ok -f bin_file();
ok -f map_file();
is read_file(bin_file(), binmode => ':raw'), "\0";

# -nb
unlink_testfiles();
write_file(asm_file(), "nop");

t_z80asm_capture("-nb ".asm_file(), "", "", 0);
ok -f obj_file();
ok ! -f map_file();
ok ! -f bin_file();

unlink_testfiles();
done_testing();
