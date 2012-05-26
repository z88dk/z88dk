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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0017.t,v 1.2 2012-05-26 18:51:10 pauloscustodio Exp $
# $Log: BUG_0017.t,v $
# Revision 1.2  2012-05-26 18:51:10  pauloscustodio
# CH_0012 : wrappers on OS calls to raise fatal error
# CH_0013 : new errors interface to decouple calling code from errors.c
#
# Revision 1.1  2012/05/23 20:00:38  pauloscustodio
# BUG_0017 : no error message if fails to create binary file chunk (option -c).
# Replace ERR_FILE_OPEN by ERR_FOPEN_READ and ERR_FOPEN_WRITE.
#
#
# BUG_0017 : no error message if fails to create binary file chunk (option -c)

use strict;
use warnings;
use Test::More;
use File::Path qw(make_path remove_tree);;
require 't/test_utils.pl';

unlink_testfiles();

# make it impossible to create one of the bin files
make_path( bn1_file() );

my $asm = "DEFB 0\n" x 0x10000;
write_file( asm_file(), $asm );
t_z80asm_capture("-r0 -b -c ".asm_file(),
				"", 
				"Error: Cannot open file 'test.bn1' for writing\n".
				"1 errors occurred during assembly\n",
				1);

remove_tree( bn1_file() );
unlink_testfiles();
done_testing();
