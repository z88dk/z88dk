#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Library of test utilities to test z80asm

use Modern::Perl;
use Exporter 'import';
use Test::More;
use Test::Differences; 
use Test::HexDifferences;
use File::Slurp;
use List::AllUtils 'uniq';
use Capture::Tiny::Extended 'capture';

our @EXPORT = qw( z80asm z80emu z80nm 
				  read_binfile write_binfile test_binfile );

our $KEEP_FILES;
our $Z80ASM = $ENV{Z80ASM} || "./z80asm";

our $AR = -d "ar" ? "ar" : "../../src/z80nm";

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
# 		bin_file - name of binary file
#------------------------------------------------------------------------------
sub z80asm {
	my(%args) = @_;

	note "Test at ",join(" ", caller);
	
	# test files
	my @asm_files;
	my $bin_file = $args{bin_file};
	my $bin = $args{bin} || "";
	my $err_text = "";
	my @err_text;	# error text for each pass
	my %err_file;
	my %o_file;
	my $num_errors;
	for (sort keys %args) {
		if (my($id) = /^asm(\d*)$/) {
			# asm[n]
			unlink("test$id.err", "test$id.o", 
			       "test$id.map", "test$id.syn", 
				   "test$id.lis", "test$id.def", 
				   <test$id*.bin>,
				   <test$id*.reloc>);
			
			$bin_file ||=    "test$id.bin";
			push @asm_files, "test$id.asm"
				unless ($args{options} || "") =~ /\@/;
			$o_file{"test$id.o"} = 1;
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
					delete $o_file{"test$id.o"} if $type eq 'error';
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
	for (sort keys %o_file) {
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
								lis |
								inc |
								bin |
								reloc |
								bn\d+ |
								map |
								o |
								lib |
								sym |
								def |
								err |
								exe |
								c |
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
	my $z80emu = $z80emu_dir.'/z80emu.lib';

	if ( ! $done_z80emu ) {
		z80asm(
			options	=> '-x'.$z80emu.' '.join(' ', sort(<$z80emu_dir/*.asm>)),
			ok		=> 1,
		);
		$done_z80emu++;
	}

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
	my($o_file, $expected_out) = @_;

	system("make -C $AR") and die;

	my $line = "[line ".((caller)[2])."]";
	my($stdout, $stderr, $return) = capture {
		system "$AR/z80nm -a $o_file";
	};
	eq_or_diff_text $stdout, $expected_out, "$line stdout";
	eq_or_diff_text $stderr, "", "$line stderr";
	ok !!$return == !!0, "$line retval";
}

1;
