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
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/TestZ80asm.pm,v 1.14 2015-01-19 22:50:01 pauloscustodio Exp $

use Modern::Perl;
use Exporter 'import';
use Test::More;
use Test::Differences; 
use Test::HexDifferences;
use File::Slurp;
use List::AllUtils 'uniq';
use Capture::Tiny::Extended 'capture';

our @EXPORT = qw( z80asm z80emu z80nm 
				  read_binfile write_binfile test_binfile
				  get_legacy );

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
# 		options - assemble options; if not defined, "-b" is used
#		ok => 1 - needed if no binary file is generated (i.e. -x)
#		error - additional error messages not in asm source files
#		bin - result binary code
#------------------------------------------------------------------------------
sub z80asm {
	my(%args) = @_;

	note "Test at ",join(" ", caller);
	
	# test files
	my @asm_files;
	my $bin_file;
	my $bin = $args{bin} || "";
	my $err_text = "";
	my @err_text;	# error text for each pass
	my %err_file;
	my %obj_file;
	my $num_errors;
	for (sort keys %args) {
		if (my($id) = /^asm(\d*)$/) {
			# asm[n]
			unlink("test$id.err", "test$id.obj", 
			       "test$id.map", "test$id.syn", 
				   "test$id.lst", "test$id.def", 
				   <test$id*.bin>);
			
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
				if (my($type, $dummy, $pass, $message) = 
					/;;\s+(error|warn)(\s*(\d+))?:\s+(.*)/) {
					$pass ||= 0;
					my $err = ($type eq 'error' ? "Error" : "Warning").
							" at file 'test$id.asm' line $line_nr: $message\n";
					$num_errors++ if $type eq 'error';
					$err_text[$pass] ||= "";
					$err_text[$pass] .= $err;
					delete $obj_file{"test$id.obj"} if $type eq 'error';
				}
				if (/;;\s+note:\s+(.*)/) {
					note($1);
				}
			}
			
			# sort error messages
			my $text = "";
			for (@err_text) {
				defined $_ and $text .= $_;
			}
			$err_text .= $text;
			if ($text) {
				$err_file{"test$id.err"} ||= "";
				$err_file{"test$id.err"} .= $text;		
			}
			@err_text = ();
		}
	}
	for (split(/\n/, $args{error} || "")) {
		$err_text .= "$_\n";
		$num_errors++ if /Error/i;
	}
	$err_text .= "$num_errors errors occurred during assembly\n" if $num_errors;
	
	# assembly command line
	my $z80asm = $Z80ASM." ".
				($args{options} || "-b").
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
		eq_or_diff scalar(read_file($_)), $err_file{$_}, "$_ contents";
	}
	
	# check object file
	for (sort keys %obj_file) {
		if ($expected_ok) {
			ok -f $_, "$_ exists";
		}
		else {
			ok ! -f $_, "$_ does not exist";
		}
	}
	
	# check binary
	if ($bin ne "") {
		test_binfile( $bin_file || "test.bin", $bin );
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
								prj |
								i ) $/ix}
		read_dir(".");
	@temp = uniq(@temp);
	
	if ( ! $KEEP_FILES ) {
		ok unlink(@temp) == @temp, "unlink temp files";
	}
	else {
		note "kept temp files";
	}
}

#------------------------------------------------------------------------------
# Build and return file name of z80emu library
#------------------------------------------------------------------------------
sub z80emu {
	our $done_z80emu;	# only once per session
	my $z80emu_dir = '../../libsrc/z80_crt0s/z80_emu';
	my $z80emu = $z80emu_dir.'/z80mu.lib';
# need to check if legacy changed and compile with -d
#	if ( ! -f $z80emu ) {
	if ( ! $done_z80emu ) {
		z80asm(
			options	=> '-x'.$z80emu.' -Mo -ns '.join(' ', <$z80emu_dir/*.asm>),
			ok		=> 1,
		);
		$done_z80emu++;
	}
#	}
	return $z80emu;
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

#------------------------------------------------------------------------------
# get legacy flag from legacy.h
sub get_legacy {
	our $legacy;
	if ( ! defined $legacy )
	{
		local $_ = read_file("legacy.h");
		$legacy = (/define\s+__LEGACY_Z80ASM_SYNTAX/) ? 1 : 0;
	}
	return $legacy;
}

#------------------------------------------------------------------------------
# check binary file
sub test_binfile {
	my($file, $expected) = @_;
	
	note "Test at ",join(" ", caller);

	ok -f $file, "binfile $file exists";
	if (-f $file) {
		my $bin_test_name = "binary (".length($expected)." bytes)";
		my $bin = read_binfile($file);
		if ($bin eq $expected) {
			ok 1, $bin_test_name;
		}
		else {
			# slow - always generates hex dump even if equal
			eq_or_dump_diff $bin, $expected, $bin_test_name;
		}
	}
}

#------------------------------------------------------------------------------
# test with z80nm
#------------------------------------------------------------------------------
sub z80nm {
	my($obj_file, $expected_out) = @_;

	system("make -C ../../support/ar") and die;
	unless ( get_legacy() ) {			# don't test old object file format
		my $line = "[line ".((caller)[2])."]";
		my($stdout, $stderr, $return) = capture {
			system "../../support/ar/z80nm -a $obj_file";
		};
		eq_or_diff_text $stdout, $expected_out, "$line stdout";
		eq_or_diff_text $stderr, "", "$line stderr";
		ok !!$return == !!0, "$line retval";
	}
}

1;
