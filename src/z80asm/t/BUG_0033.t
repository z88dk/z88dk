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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0033.t,v 1.3 2014-01-11 01:29:46 pauloscustodio Exp $
# $Log: BUG_0033.t,v $
# Revision 1.3  2014-01-11 01:29:46  pauloscustodio
# Extend copyright to 2014.
# Move CVS log to bottom of file.
#
# Revision 1.2  2013/05/11 00:30:55  pauloscustodio
# Delete zcc options file
#
# Revision 1.1  2013/05/06 22:06:22  pauloscustodio
# BUG_0033 : -d option fails if .asm does not exist
# When building test.o from test.c, the test.asm file is removed by zcc.
# If the .o is then linked into a library with the -d option to skip
# assembling, z80asm fails with error
# "Cannot open file 'test.asm' for reading".
# Bug introduced when replaced TestAsmFile() by query_assemble() in
# z80asm.c 1.78.
#
#
# BUG_0033 : -d option fails if .asm does not exist

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

unlink_testfiles();

write_file(c_file(), "int test() { return 1; }\n");
is system("zcc +zx -O3 -vn -make-lib -Wn43 ".c_file()), 0, "compile ".c_file();
ok -f o_file(), o_file()." exists";

t_z80asm_capture("-d -Mo -x".lib2_file()." ".asm_file(), "", "", 0);
ok -f lib2_file(), lib2_file()." exists";

unlink_testfiles('zcc_opt.def');
done_testing();
