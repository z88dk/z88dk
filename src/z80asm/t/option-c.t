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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/option-c.t,v 1.1 2011-07-11 15:46:33 pauloscustodio Exp $
# $Log: option-c.t,v $
# Revision 1.1  2011-07-11 15:46:33  pauloscustodio
# Added test scripts for all z80asm options
#
#
# Test option -c

use strict;
use warnings;
use File::Slurp;
use Test::More;
require 't/test_utils.pl';

my $base = asm_file(); $base =~ s/\.\w+$//;

my $asm = "defb 0xAA\n" x 65536;
my $bin = "\xAA"        x 65536;

# one block
t_z80asm_ok(0, $asm, $bin);

# 4 16K blocks
t_z80asm_capture("-r0 -b -c ".asm_file(), "", "", 0);
is read_file($base.".bn0", binary => ':raw'), substr($bin, 0, 16384);
is read_file($base.".bn1", binary => ':raw'), substr($bin, 0, 16384);
is read_file($base.".bn2", binary => ':raw'), substr($bin, 0, 16384);
is read_file($base.".bn3", binary => ':raw'), substr($bin, 0, 16384);

unlink_testfiles($base.".bn0", $base.".bn1", $base.".bn2", $base.".bn3");
done_testing();

