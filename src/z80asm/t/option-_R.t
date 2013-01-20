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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/option-_R.t,v 1.2 2013-01-20 21:24:29 pauloscustodio Exp $
# $Log: option-_R.t,v $
# Revision 1.2  2013-01-20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.1  2011/07/11 15:46:33  pauloscustodio
# Added test scripts for all z80asm options
#
#
# Test option -R, -nR

use strict;
use warnings;
use File::Slurp;
use Test::More;
require 't/test_utils.pl';

# copied from z80asm.c:
# unsigned char reloc_routine[] =
my $reloc_routine =
"\x08\xD9\xFD\xE5\xE1\x01\x49\x00\x09\x5E\x23\x56\xD5\x23\x4E\x23".
"\x46\x23\xE5\x09\x44\x4D\xE3\x7E\x23\xB7\x20\x06\x5E\x23\x56\x23".
"\x18\x03\x16\x00\x5F\xE3\x19\x5E\x23\x56\xEB\x09\xEB\x72\x2B\x73".
"\xD1\xE3\x2B\x7C\xB5\xE3\xD5\x20\xDD\xF1\xF1\xFD\x36\x00\xC3\xFD".
"\x71\x01\xFD\x70\x02\xD9\x08\xFD\xE9";

my $asm = "start: jp start";
my $bin = "\xC3\x00\x00";
my $reloc_data = "\x01\x00\x01\x00\x01";

# -R
unlink_testfiles();
write_file(asm_file(), $asm);
t_z80asm_capture("-r0 -b -R ".asm_file(), "Relocation header is 78 bytes.\n", "", 0);
t_binary(read_file(bin_file(), binmode => ':raw'), $reloc_routine.$reloc_data.$bin);

# -nR
unlink_testfiles();
write_file(asm_file(), $asm);
t_z80asm_capture("-r0 -b -R -nR ".asm_file(), "", "", 0);
t_binary(read_file(bin_file(), binmode => ':raw'), $bin);

unlink_testfiles();
done_testing();
