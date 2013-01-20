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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0012.t,v 1.3 2013-01-20 21:24:28 pauloscustodio Exp $
#
# BUG_0012 : binfilename[] array is too short, should be FILENAME_MAX

use strict;
use warnings;
use Test::More;
use File::Basename;
require 't/test_utils.pl';

write_file(asm_file(), "nop");
my $bin_file = dirname(bin_file()) . ("/." x 32) . "/" . basename(bin_file());
ok length($bin_file) > 64, "Bin file $bin_file";
t_z80asm_capture("-r0 -b -o$bin_file ".asm_file(), "", "", 0);
ok -f bin_file(), bin_file()." exists";
ok -f $bin_file, $bin_file." exists";
t_binary(read_binfile(bin_file()), "\0");
t_binary(read_binfile($bin_file), "\0");

unlink_testfiles();
done_testing();
