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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/bugfixes.t,v 1.1 2014-04-26 08:12:04 pauloscustodio Exp $
#
# Test bugfixes

use strict;
use warnings;
use File::Slurp;
use File::Basename;
use File::Copy;
use Test::Differences; 
use Test::More;
require 't/test_utils.pl';

#------------------------------------------------------------------------------
# BUG_0049: Making a library with -d and 512 object files fails - Too many open files
diag "BUG_0049";
#------------------------------------------------------------------------------
{
	unlink_testfiles();
	my @asm_list;
	my @obj_list;
	for (1..512) {
		my $asm_file = "test_$_.asm";
		my $obj_file = "test_$_.obj";
		push @asm_list, $asm_file;
		push @obj_list, $obj_file;
		write_file($asm_file, " public test_$_ \n defc test_$_ = $_\n");
	}
	write_file(prj_file(), join("\n", @asm_list), "\n");
	
	# assemble all first
	t_z80asm_capture('-ns -nm @'.prj_file(), "", "", 0);
	
	# assemble all with -d, make lib - failed with too many open files
	t_z80asm_capture('-d -ns -nm -x'.lib_file().' @'.prj_file(), "", "", 0);
	
	unlink_testfiles(@asm_list, @obj_list);
}

ok 1;




unlink_testfiles();
done_testing();

# $Log: bugfixes.t,v $
# Revision 1.1  2014-04-26 08:12:04  pauloscustodio
# BUG_0049: Making a library with -d and 512 object files fails - Too many open files
# Error caused by z80asm not closing the intermediate object files, when
# assembling with -d.
#
