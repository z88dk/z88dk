#!/usr/bin/perl

# z80asm2 tests
#
# Copyright (C) Paulo Custodio, 2011-2019
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/

use Modern::Perl;
use Test::More;
use Path::Tiny;
use Config;

# run z80asm from .
$ENV{PATH} = ".".$Config{path_sep}.$ENV{PATH};

my @code;
sub add { 
	my($asm, @bytes) = @_;
	$asm = "$asm\n"; 
	my $bin .= join("", map {chr} @bytes);
	push @code, [$asm, $bin];
}

sub parse {
	my($text) = @_;
	my @lines = split(/\n/, $text);
	for (@lines) {
		my($asm, $bytes) = split(/\s+;\s+/, $_);
		my @bytes = map {hex} split(' ', $bytes);
		add($asm, @bytes);
	}
}

sub run {
	my($cmd) = @_;
	ok 1, $cmd;
	ok 0==system($cmd), "exit value";
}

sub assemble {
	my(@ops) = @_;
	
	my $asm = "";
	my $bin = "";
	for (@ops) {
		$asm .= $_->[0];
		$bin .= $_->[1];
	}
	
	path('test.asm')->spew($asm);
	path('test.exp')->spew_raw($bin);

	unlink 'test.bin';
	run("z80asm -b -l test.asm");
	if (!-f 'test.bin' || path('test.bin')->slurp_raw ne $bin) {
		ok 0, "z80asm binary different";
		return 0;
	}

	unlink 'test.bin';
	run("z80asm2 test.asm");
	if (!-f 'test.bin' || path('test.bin')->slurp_raw ne $bin) {
		ok 0, "z80asm2 binary different";
		return 0;
	}
	
	unlink 'test.asm', 'test.bin', 'test.exp', 'test.o', 'test.lis';
	return 1;
}

sub run_tests {
	my(@ops) = @_;
	
	my $test = scalar(@ops)." opcodes";
	my $ok = assemble(@ops);
	ok $ok, $test;
	return $ok if $ok;

	# drill down to find error
	diag "Failed:\n".path('test.asm')->slurp;
	
	if (@ops <= 1) {
		diag "Error in:\n", path('test.asm')->slurp, "\n";
		die "failed\n";
	}
	else {
		my $mid = int(@ops / 2);
		return 0 if !run_tests(@ops[0 .. $mid-1]);
		return 0 if !run_tests(@ops[$mid .. $#ops]);
		die "failed";
	}
}	

parse(join("", grep {!/\@__z80asm__|\.a/} path('../cpu/cpu_test_z80_ok.asm')->lines));

run_tests(@code);
done_testing;
