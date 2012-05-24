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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0018.t,v 1.1 2012-05-24 10:58:39 pauloscustodio Exp $
# $Log: BUG_0018.t,v $
# Revision 1.1  2012-05-24 10:58:39  pauloscustodio
# BUG_0018 : stack overflow in '@' includes - wrong range check
#
#
# Test inclusion of source files by source list
# BUG_0018 : stack overflow in '@' includes - wrong range check

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

my $levels = 20;
my @del_files;

my @asm_files;
my @asmlst_files;
my $bin;

for (0 .. $levels) {
	(my $asm_file = asm1_file()) =~ s/1/$_/; 
	(my $asmlst_file = asmlst1_file()) =~ s/1/$_/; 
	
	push @asm_files, $asm_file;
	push @asmlst_files, $asmlst_file;
	$bin .= chr($_);
}

unlink_testfiles();

write_file( asmlst_file(), '@'.$asmlst_files[0] );
for (0 .. $levels) {
	write_file( $asmlst_files[$_], 
				$asm_files[$_]."\n".
				($_ == $levels ? '' : 
					'@'.$asmlst_files[$_+1] ) );
	write_file( $asm_files[$_], "DEFB $_" );
}

t_z80asm_capture('-r0 -b -l -o'.bin_file().' @'.asmlst_file(), "", "", 0);
t_binary(read_binfile(bin_file()), $bin);


unlink_testfiles();
done_testing();
