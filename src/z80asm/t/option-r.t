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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/option-r.t,v 1.1 2011-07-11 15:46:33 pauloscustodio Exp $
# $Log: option-r.t,v $
# Revision 1.1  2011-07-11 15:46:33  pauloscustodio
# Added test scripts for all z80asm options
#
#
# Test option -r

use strict;
use warnings;
use File::Slurp;
use Test::More;
require 't/test_utils.pl';

# -r0
unlink_testfiles();
write_file(asm_file(), "start: jp start");

t_z80asm_capture("-r0 -b ".asm_file(), "", "", 0);
t_binary(read_file(bin_file(), binmode => ':raw'), "\xC3\x00\x00");

# -r100
unlink_testfiles();
write_file(asm_file(), "start: jp start");

t_z80asm_capture("-r100 -b ".asm_file(), "", "", 0);
t_binary(read_file(bin_file(), binmode => ':raw'), "\xC3\x00\x01");

unlink_testfiles();
done_testing();
