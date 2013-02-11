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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/option-l-s.t,v 1.4 2013-02-11 21:54:38 pauloscustodio Exp $
# $Log: option-l-s.t,v $
# Revision 1.4  2013-02-11 21:54:38  pauloscustodio
# BUG_0026 : Incorrect paging in symbol list
#
# Revision 1.3  2013/01/24 23:03:03  pauloscustodio
# Replaced (unsigned char) by (byte_t)
# Replaced (unisigned int) by (size_t)
# Replaced (short) by (int)
#
# Revision 1.2  2013/01/20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.1  2011/07/11 15:46:33  pauloscustodio
# Added test scripts for all z80asm options
#
#
# Test option -l, -nl, -s, -ns

use strict;
use warnings;
use File::Slurp;
use Test::More;
use Test::Differences; 
require 't/test_utils.pl';

#------------------------------------------------------------------------------
# Page handling
my $PAGE_SIZE = 61;
my $LINE_SIZE = 121;
my $COLUMN_WIDTH = 32;
my $linenr;
my $pagenr;
my $page_linenr;

#------------------------------------------------------------------------------
my $addr = 0;
my $lbl_base = 2 * 2 * 256;
my %lbl_page;
my %lbl_addr;
my %lbl_global;

#------------------------------------------------------------------------------
my @asm;
my @bin;
my @lst;

#------------------------------------------------------------------------------
# build test assembly
first_line();
use_labels();
define_labels();
use_labels();
add_end_line();

my $asm = join("\n", @asm);
#"
#	xlib loop
#	xdef main
#	defb 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32
#main:	ld b,10
#loop:	djnz loop
#	ret
#";
my $bin = join('', @bin);
#	pack("C*", 
#	0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,
#	0x06, 10,
#	0x10, -2 & 0xFF,
#	0xC9
#);



# no symbol table, no list
t_z80asm(
	asm		=> $asm,
	bin		=> $bin,
	options	=> '-nl -ns',
	nolist	=> 1,
);

# list file implies no symbol table
for my $option ('-l', '-l -s') {
	t_z80asm(
		asm		=> $asm,
		bin		=> $bin,
		options	=> $option,
		nolist	=> 1,
	);
	compare_list_file(lst_file(), @lst, sym_lines(1));
}

# no list file implies symbol table
for my $option ('', '-nl', '-s', '-nl -s') {
	t_z80asm(
		asm		=> $asm,
		bin		=> $bin,
		options	=> $option,
		nolist	=> 1,
	);
	compare_list_file(sym_file(), sym_lines(0));
}

unlink_testfiles();
done_testing();

#------------------------------------------------------------------------------
# Page handling
sub first_line {
	$linenr = 1;
	$pagenr = 1;
	$page_linenr = 1;
}

sub next_line {
	$linenr++;
	$page_linenr++;
	if ($page_linenr > $PAGE_SIZE) {
		$page_linenr = 1;
		$pagenr++;
	}
}

#------------------------------------------------------------------------------
# define lblxxx labels
sub define_labels {
	$addr == $lbl_base or die "lbl_base should be $addr";
	
	for (0..255) {
		my $label = sprintf("lbl%03d", $_);
		my $asm   = sprintf("$label: defb %3d", $_);
		push @asm, $asm;
		push @bin, pack("C", $_);
		push @lst, sprintf("%-5d %04X  %02X          $asm", 
						   $linenr, $addr, 
						   $_, $_);

		unshift $lbl_page{$label}, $pagenr;
		
		$lbl_addr{$label} = $addr;
		
		$addr++;
		next_line();
	}
	
	# add global labels
	for (0..255) {
		my $label = sprintf("global%03d", $_);
		my $asm1  =         "        xdef $label";
		my $asm2  = sprintf("$label: defb %3d", $_);
		
		push @asm, $asm1;
		push @asm, $asm2;
		push @bin, pack("C", $_);

		push @lst, sprintf("%-5d %04X              $asm1", 
						   $linenr, $addr);
		$lbl_page{$label}[0] = $pagenr;
		next_line();

		push @lst, sprintf("%-5d %04X  %02X          $asm2", 
						   $linenr, $addr, 
						   $_);

		unshift $lbl_page{$label}, $pagenr if $pagenr != $lbl_page{$label}[0];
		$lbl_global{$label} = 1;
		
		$lbl_addr{$label} = $addr;
		
		$addr++;
		next_line();
	}
	
	# add labels of all sizes
	for (2..255) {
		my $label = substr("x" . (($_.'_') x $_), 0, $_);
		my $asm   = "$label: defb $_";
		next if length($asm) + 2 > 255;
		
		push @asm, $asm;
		push @bin, pack("C", $_);
		
		push @lst, sprintf("%-5d %04X  %02X          $asm", 
						   $linenr, $addr, $_);
		$lbl_page{$label}[0] = $pagenr;
		$lbl_addr{$label} = $addr;
		
		$addr++;
		next_line();
	}		
}

#------------------------------------------------------------------------------
# use lblxxx labels
sub use_labels {
	for (0..255) {
		my $label = sprintf("lbl%03d", $_);
		my $asm   = sprintf("defw %3d, $label", $_);
		push @asm, $asm;
		push @bin, pack("v*", $_, $lbl_base + $_);
		push @lst, sprintf("%-5d %04X  %02X %02X %02X %02X $asm", 
						   $linenr, $addr, 
						   $_, 0, 
						   ($lbl_base + $_) & 0xFF, 
						   (($lbl_base + $_) >> 8) & 0xFF);

		$lbl_page{$label} ||= [];
		push $lbl_page{$label}, $pagenr;
		
		$addr += 4;
		next_line();
	}
}

#------------------------------------------------------------------------------
# add end line with final assembly address
sub add_end_line {
	push @lst, sprintf("%-5d %04X              ", 
					   $linenr, $addr);
	next_line();
}

#------------------------------------------------------------------------------
# Return list of lines of symbol table
sub sym_lines {
	my($show_pages) = @_;
	my @sym;
	
	push @sym, "";
	push @sym, "";
	push @sym, "Local Module Symbols:";
	push @sym, "";
	
	for (sort keys %lbl_addr) {
		push @sym, format_sym_line($_, $show_pages) unless $lbl_global{$_};
	}
	
	push @sym, "";
	push @sym, "";
	push @sym, "Global Module Symbols:";
	push @sym, "";
	
	for (sort keys %lbl_addr) {
		push @sym, format_sym_line($_, $show_pages) if $lbl_global{$_};
	}
	
	return @sym;
}

sub format_sym_line {
	my($label, $show_pages) = @_;
	
	my $line = uc($label);
	my $space = $COLUMN_WIDTH - length($label);
	my $tabs  = int($space / 8);
	
	$line .= "\t" x ($space % 8 ? $tabs + 1 : $tabs);
	$line .= "= " . sprintf("%08X", $lbl_addr{$label});
	
	if ($show_pages) {
		$line .= " :";
		my @pages = @{$lbl_page{$label}};
		$line .= sprintf("%4d", shift @pages) . '*';
		while (@pages) {
			$line .= sprintf("%4d", shift @pages);
		}
		$line .= " ";
	}
	
	return $line;
}

#------------------------------------------------------------------------------
# compare result file with list of expected lines
sub compare_list_file {
	my($file, @expected) = @_;

	my $line = "[line ".((caller)[2])."]";

	my @got = read_file($file);
	chomp(@got);
	
	insert_headers(get_copyright(), get_unix_date($got[0]), $file, \@expected);
	
	eq_or_diff \@got, \@expected, "$line compare $file";
}

# insert headers every $PAGE_SIZE lines
sub insert_headers {
	my($copyright, $date, $file, $lines) = @_;
	my $i = 0;
	my $page = 1;
	
	while ($i < @$lines) {
		my @insert;
		push @insert, "\f" if $i > 0;
		push @insert, $copyright . " " x ($LINE_SIZE - length($copyright) - length($date)) . $date;
		push @insert, "Page ".sprintf("%03d", $page) . " " x ($LINE_SIZE - 10 - length($file)) . "'$file'";
		push @insert, "";
		push @insert, "";
		
		splice(@$lines, $i, 0, @insert);
		
		$page++;
		$i += @insert + $PAGE_SIZE;
	}
	push @$lines, "\f";
}


