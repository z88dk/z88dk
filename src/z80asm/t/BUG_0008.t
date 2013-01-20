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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0008.t,v 1.3 2013-01-20 21:24:28 pauloscustodio Exp $
# $Log: BUG_0008.t,v $
# Revision 1.3  2013-01-20 21:24:28  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.2  2012/04/22 19:37:46  pauloscustodio
# Use read_binfile()
#
# Revision 1.1  2011/08/18 21:42:58  pauloscustodio
# Test BUG_0008 : code block of 64K is read as zero
#
#
# Test BUG_0008 : code block of 64K is read as zero - see hist.c for details

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

write_file(asm_file(), "defb 0xAA \n" x 65536);
t_z80asm_capture(asm_file(), "", "", 0);
t_binary(read_binfile(obj_file()),
	 objfile(NAME => 'test',
		 CODE => "\xAA" x 65536));
t_z80asm_capture("-r0 -d -b ".asm_file(), "", "", 0);	# use obj, dont assemble
t_binary(read_binfile(bin_file()),
	 "\xAA" x 65536);

unlink_testfiles();
done_testing();
