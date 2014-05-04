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
#
# Library of test utilities to test z80asm
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/TestZ80asm.pm,v 1.1 2014-05-04 16:48:52 pauloscustodio Exp $

use Modern::Perl;
use Exporter 'import';
use Test::More;
use Test::Differences; 
use File::Slurp;
use Data::HexDump;
use List::AllUtils 'uniq';
use Capture::Tiny::Extended 'capture';

our @EXPORT = qw( z80asm read_binfile write_binfile );

our $KEEP_FILES;
our $Z80ASM = $ENV{Z80ASM} || "./z80asm";

#------------------------------------------------------------------------------
# startup and cleanup
#------------------------------------------------------------------------------
BEGIN {
	$KEEP_FILES	 = grep {/-keep/} @ARGV; 
}

END {
	unlink_temp();
	done_testing();
}
		
#------------------------------------------------------------------------------
# z80asm - run an assembly session, check results
#	inputs:
#		asm[N] - assembly source, including:
#						;; 3E 00			- binary code of instruction
#						;; note: message	- show note
#						;; error: message	- expect error message in this line
#						;; warn: message	- expect warning message in this line
#						^;; error|warn:		- expect pass2 error at this module
# 		options - assemble options; if not defined, "-b -r0" is used
#		ok => 1 - needed if no binary file is generated (i.e. -x)
#------------------------------------------------------------------------------
sub z80asm {
	my(%args) = @_;

	note "Test at ",join(" ", caller);
	
	# test files
	my @asm_files;
	my $bin_file;
	my $bin = "";
	my $err_text = "";
	my %err_file;
	my %obj_file;
	my $num_errors;
	for (sort keys %args) {
		if (my($id) = /^asm(\d*)$/) {
			# asm[n]
			unlink("test$id.err", "test$id.obj", "test$id.bin");
			
			$bin_file ||=    "test$id.bin";
			push @asm_files, "test$id.asm"
				unless ($args{options} || "") =~ /\@/;
			$obj_file{"test$id.obj"} = 1;
			write_file("test$id.asm", $args{$_});
			
			# parse asm code, build errors and bin
			my $line_nr = 0;
			for (split(/\n/, $args{$_})) {
				$line_nr++;
				if (/;;((\s+[0-9A-F][0-9A-F])+)/) {
					for (split(' ', $1)) {
						$bin .= chr(hex($_));
					}
				}
				if (/(\s*);;\s+(error|warn):\s+(.*)/) {
					my $err = ($2 eq 'error' ? "Error" : "Warning ").
							" at file 'test$id.asm' ".
							($1 eq '' ? "module 'test$id'" : "line $line_nr").
							": $3\n";
					$num_errors++ if $2 eq 'error';
					$err_text .= $err;
					$err_file{"test$id.err"} ||= "";
					$err_file{"test$id.err"} .= $err;		
					delete $obj_file{"test$id.obj"} if $2 eq 'error';
				}
				if (/;;\s+note:\s+(.*)/) {
					note($1);
				}
			}
		}
	}
	$err_text .= "$num_errors errors occurred during assembly\n" if $num_errors;
	
	# assembly command line
	my $z80asm = $Z80ASM." ".
				($args{options} || "-b -r0").
				" @asm_files";

	# assemble
	ok 1, $z80asm;
	my($stdout, $stderr, $return) = capture { system $z80asm; };
	
	# check output
	eq_or_diff_text $stdout, "", "stdout";
	eq_or_diff_text $stderr, $err_text, "stderr";
	my $expected_ok = ($bin ne "") || $args{ok};
	is !$return, !!$expected_ok, "exit";
	
	# check error file
	for (sort keys %err_file) {
		ok -f $_, "$_ exists";
		eq_or_diff read_file($_), $err_file{$_}, "$_ contents";
	}
	
	# check object file
	for (sort keys %obj_file) {
		ok -f $_, "$_ exists";
	}
	
	# check binary
	if ($bin ne "") {
		my $out_bin = read_binfile($bin_file);
		if ($out_bin eq $bin) {
			is $out_bin, $bin, "binary";
		}
		else {
			eq_or_diff HexDump($out_bin), HexDump($bin), "binary";
		}
	}
}

#------------------------------------------------------------------------------
# delete test files
#------------------------------------------------------------------------------
sub unlink_temp {
	my(@temp) = @_;
	push @temp, 
		grep { -f $_ }
		grep {/^ test .* \. (?: asm |
								lst |
								inc |
								bin |
								bn\d+ |
								map |
								obj |
								lib |
								sym |
								def |
								err |
								exe |
								c |
								o |
								asmlst |
								prj ) $/ix}
		read_dir(".");
	@temp = uniq(@temp);
	
	if ( ! $KEEP_FILES ) {
		ok unlink(@temp) == @temp, "unlink temp files @temp";
	}
	else {
		note "kept temp files @temp";
	}
}

#------------------------------------------------------------------------------
sub read_binfile {
	my($file) = @_;
	return scalar read_file($file, binmode => ':raw');
}

#------------------------------------------------------------------------------
sub write_binfile {
	my($file, $data) = @_;
	write_file($file, {binmode => ':raw'}, $data);
}

1;

# $Log: TestZ80asm.pm,v $
# Revision 1.1  2014-05-04 16:48:52  pauloscustodio
# Move tests of BUG_0001 and BUG_0002 to bugfixes.t, using TestZ80asm.pm
#

