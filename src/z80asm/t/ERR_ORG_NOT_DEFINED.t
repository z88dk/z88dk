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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/ERR_ORG_NOT_DEFINED.t,v 1.1 2013-04-07 23:34:19 pauloscustodio Exp $
# $Log: ERR_ORG_NOT_DEFINED.t,v $
# Revision 1.1  2013-04-07 23:34:19  pauloscustodio
# CH_0020 : ERR_ORG_NOT_DEFINED if no ORG given
# z80asm no longer asks for an ORG address from the standard input
# if one is not given either by an ORG statement or a -r option;
# it exists with an error message instead.
# The old behaviour was causing wrong build scripts to hang waiting
# for input.
#
#

use strict;
use warnings;
use Test::More;
use Capture::Tiny::Extended 'capture';
require 't/test_utils.pl';

t_z80asm(
	org		=> -1,
	asm		=> "org 0x1000 \n start: defw start",
	bin		=> "\x00\x10",
);

t_z80asm(
	org		=> 0x1000,
	asm		=> "start: defw start",
	bin		=> "\x00\x10",
);

unlink_testfiles();
write_file( asm_file(), "start: defw start" );
my($stdout, $stderr, $return) = capture {
	system z80asm()." -l -b ".asm_file();
};
is $stdout, "", "output";
is $stderr, "Error at module 'TEST': ORG not defined\n1 errors occurred during assembly\n", "error";
ok -f err_file(), "error file";
is read_file( err_file() ), "Error at module 'TEST': ORG not defined\n", "error file ok";
ok -f lst_file(), "lst generated in assembly phase, ok";
ok -f obj_file(), "obj generated in assembly phase, ok";
ok ! -f bin_file(), "no bin file";

unlink_testfiles();
done_testing();
