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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/ERR_FOPEN_WRITE.t,v 1.3 2013-01-20 21:24:29 pauloscustodio Exp $
#
# Test ERR_FOPEN_WRITE

use strict;
use warnings;
use Test::More;
use File::Path qw(make_path remove_tree);;
require 't/test_utils.pl';

unlink_testfiles();
make_path( err_file() );
write_file( asm_file(), 'nop' );
t_z80asm_capture("-r0 -b -c ".asm_file(),
				"", 
				"Error at file 'test.asm': Cannot open file 'test.err' for writing\n".
				"1 errors occurred during assembly\n",
				1);
remove_tree( err_file() );

unlink_testfiles();
make_path( lst_file() );
write_file( asm_file(), 'nop' );
t_z80asm_capture("-l -r0 -b -c ".asm_file(),
				"", 
				"Error at file 'test.asm': Cannot open file 'test.lst' for writing\n".
				"1 errors occurred during assembly\n",
				1);
remove_tree( lst_file() );

unlink_testfiles();
make_path( sym_file() );
write_file( asm_file(), 'nop' );
t_z80asm_capture("-r0 -b -c ".asm_file(),
				"", 
				"Error at file 'test.asm': Cannot open file 'test.sym' for writing\n".
				"1 errors occurred during assembly\n",
				1);
remove_tree( sym_file() );

unlink_testfiles();
make_path( obj_file() );
write_file( asm_file(), 'nop' );
t_z80asm_capture("-l -r0 -b -c ".asm_file(),
				"", 
				"Error at file 'test.asm': Cannot open file 'test.obj' for writing\n".
				"1 errors occurred during assembly\n",
				1);
remove_tree( obj_file() );

unlink_testfiles();
make_path( bin_file() );
write_file( asm_file(), 'nop' );
t_z80asm_capture("-r0 -b -c ".asm_file(),
				"", 
				"Error: Cannot open file 'test.bin' for writing\n".
				"1 errors occurred during assembly\n",
				1);
remove_tree( bin_file() );

# BUG_0017.t test case for -c option



unlink_testfiles();
done_testing();
