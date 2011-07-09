#!/usr/bin/perl

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/test_utils.pl,v 1.2 2011-07-09 17:36:09 pauloscustodio Exp $
# $Log: test_utils.pl,v $
# Revision 1.2  2011-07-09 17:36:09  pauloscustodio
# Copied cvs log into $Log$ history
#
# Revision 1.1  2011/07/09 01:02:45  pauloscustodio
# Started to build test suite in t/ *.t unsing Perl prove. Included test for all standard
# Z80 opcodes; need to be extended with directives and opcodes for Z80 variants.
#
# Common utils for tests

use strict;
use warnings;
use Capture::Tiny::Extended 'capture';
use File::Slurp;

my $STOP_ON_ERR = grep {/-stop/} @ARGV; 
my $KEEP_FILES  = grep {/-keep/} @ARGV; 
my $test   	 = "test";

sub z80asm   { $ENV{Z80ASM} || "z80asm" }
sub asm_file {"$test.asm"}
sub lst_file {"$test.lst"}
sub inc_file {"$test.inc"}
sub bin_file {"$test.bin"}
sub map_file {"$test.map"}
sub obj_file {"$test.obj"}
sub lib_file {"$test.lib"}
sub sym_file {"$test.sym"}
sub err_file {"$test.err"}

sub unlink_testfiles {
	if ($KEEP_FILES) {
		ok 0, "-keep : kept test files";
	}
	else {
		my @files = (asm_file(), lst_file(), inc_file(), bin_file(), map_file(), 
					 obj_file(), lib_file(), sym_file(), err_file());
		my $count = 0;
		map {$count++ if -f} @files;
		is unlink(@files), $count, "unlink $count testfiles";
	}
}

sub t_z80asm_error {
	my($code, $expected_err, $options) = @_;

	(my $test_name = $code) =~ s/\n.*/.../s;
	ok 1, "[line ".((caller)[2])."] t_z80asm_error $test_name - $expected_err";
	
	unlink_testfiles();
	write_file(asm_file(), "$code\n");
	
	my $cmd = z80asm()." ".($options || "")." ".asm_file();
	ok 1, $cmd;
	my($stdout, $stderr, $return) = capture {
		system $cmd;
	};
	is $stdout, "", "stdout";
	is $stderr, $expected_err."\n".
				"1 errors occurred during assembly\n", "stderr";
	ok $return != 0, "exit value";
	ok -f err_file(), "error file found";
	is read_file(err_file(), err_mode => 'quiet'), 
				$expected_err."\n", "error in error file";

	exit 1 if $return == 0 && $STOP_ON_ERR;
}

sub t_z80asm_ok {
	my($address_hex, $code, $expected_binary, $options) = @_;

	(my $test_name = $code) =~ s/\n.*/.../s;
	ok 1, "[line ".((caller)[2])."] t_z80asm_ok $test_name - ".
		hexdump(substr($expected_binary, 0, 16)).
		(length($expected_binary) > 16 ? "..." : "");
	
	unlink_testfiles();
	write_file(asm_file(), "org 0x$address_hex\n$code\n");
	
	my $cmd = z80asm()." -l -b ".($options || "")." ".asm_file();
	ok 1, $cmd;
	my($stdout, $stderr, $return) = capture {
		system $cmd;
	};
	is $stdout, "", "stdout";
	is $stderr, "", "stderr";
	ok $return == 0, "exit value";
	ok ! -f err_file(), "no error file";
	ok -f bin_file(), "bin file found";
	
	my $binary = read_file(bin_file(), binmode => ':raw', err_mode => 'quiet');
	$binary //= "";
	my $ok = $binary eq $expected_binary;
	ok $ok, "assembly binary";
	if (! $ok) {
		my $addr = 0;
		$addr++ while (substr($binary, $addr, 1) eq substr($expected_binary, $addr, 1));
		diag sprintf("Assembly differs at %04X:\n".
					 "     got: %s\n".
					 "expected: %s\n", 
					 $addr, 
					 hexdump(substr($binary, $addr, 16)),
					 hexdump(substr($expected_binary, $addr, 16)));
	}

	exit 1 if $return != 0 && $STOP_ON_ERR;
}

sub hexdump {
	return join(' ', map { sprintf("%02X", ord($_)) } split(//, shift));
}

1;
