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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/opcodes.t,v 1.1 2014-03-29 01:19:41 pauloscustodio Exp $

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

assemble(<<'END');
start:
	ex	af,af		; 08
	ex	af,af'		; 08
END

unlink_testfiles();
done_testing();

# assemble the given code, compare
sub assemble {
	my($code) = @_;
	
	my $addr = 0;
	my %label;
	my $asm = "";
	my $bin = "";
	
	for (split(/\n/, $code)) {
		if (/^(\w+):/) {
			$label{$1} = $addr;
		}
		
		$asm .= "$_\n";

		if (/^\s/) {
			my $bytes = $_; $bytes =~ s/^[^;]+;\s*//;
			for (split(' ', $bytes)) {
				$bin .= chr(hex($_));
				$addr++;
			}
		}
	}
	
	t_z80asm(
		asm		=> $asm,
		bin		=> $bin,
	);
}


# $Log: opcodes.t,v $
# Revision 1.1  2014-03-29 01:19:41  pauloscustodio
# Accept both "ex af,af" and "ex af,af'"
#
