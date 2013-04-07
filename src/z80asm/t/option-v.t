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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/option-v.t,v 1.3 2013-04-07 22:30:48 pauloscustodio Exp $
# $Log: option-v.t,v $
# Revision 1.3  2013-04-07 22:30:48  pauloscustodio
# Test output with 3 input lines
#
# Revision 1.2  2013/01/20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.1  2011/07/11 15:46:33  pauloscustodio
# Added test scripts for all z80asm options
#
#
# Test option -v, -nv

use strict;
use warnings;
use File::Slurp;
use Test::More;
require 't/test_utils.pl';

# -v
unlink_testfiles();
write_file(asm_file(), " nop \n nop \n nop");
t_z80asm_capture("-r0 -b -v ".asm_file(),
		"Assemble all files
Create symbol table file.
Link/relocate assembled modules.
Create address map file.

Assembling 'test.asm'...
Pass1...
Pass2...
Size of module is 3 bytes

Total of 3 lines assembled.
linking module(s)...
Pass1...
ORG address for code is 0000
Code size of linked modules is 3 bytes
Pass2...
Creating map...
Code generation completed.
", 
		"",
		0);
ok -f obj_file();
ok -f bin_file();
is read_file(bin_file(), binmode => ':raw'), "\0\0\0";

# -nv
unlink_testfiles();
write_file(asm_file(), "nop");

t_z80asm_capture("-r0 -b -nv ".asm_file(), "", "", 0);
ok -f obj_file();
ok -f bin_file();
is read_file(bin_file(), binmode => ':raw'), "\0";

unlink_testfiles();
done_testing();
