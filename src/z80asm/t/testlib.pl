#------------------------------------------------------------------------------
# Z88DK Z80 Macro Assembler
#
# Plain Perl (no CPAN libraries) test library
#
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------
use strict;
use warnings;
use v5.10;

use Test::More;

sub slurp {
	my($file) = @_;
	local $/;
	open(my $fh, "<:raw", $file) or die "$file: $!";
	return <$fh>;
}

sub spew {
	my($file, @text) = @_;
	open(my $fh, ">:raw", $file) or die "$file: $!";
	print $fh @text;
}

sub run {
	my($cmd, $return, $out, $err) = @_;
	$return //= 0;
	$out //= '';
	$err //= '';
	
	$cmd .= " >test.stdout 2>test.stderr";
	
	ok 1, $cmd;
	ok !!$return == !!system($cmd), "exit value";
	
	my $gotout = slurp("test.stdout");
	my $goterr = slurp("test.stderr");
	
	if ($out eq "IGNORE") {
		diag "test.stdout: ", $gotout;
	}
	else {
		is norm_nl($gotout), norm_nl($out), "test.stdout";
	}
	
	if ($err eq "IGNORE") {
		diag "test.stderr: ", $goterr;
	}
	else {
		is norm_nl($goterr), norm_nl($err), "test.stderr";
	}
	
	if (Test::More->builder->is_passing) {
		unlink "test.stdout", "test.stderr";
	}
}

sub norm_nl {
	my(@lines) = @_;
	for (@lines) {
		s/[ \t\r]+\n/\n/g;
	}
	return wantarray ? @lines : join('', @lines);
}

sub hexdump {
	my($str) = @_;
	my $ret = '';
	for (split //, $str) {
		$ret .= sprintf("%02X ", ord($_));
	}
	return $ret;
}

sub unlink_tests {
	if ($ENV{KEEP}) {
		diag "kept test files";
	}
	else {
		if (Test::More->builder->is_passing) {
			for (qw(test.asm test.bin test.c test.err test.lis test.map test.o test.out)) {
				-f $_ and ok unlink($_), "unlink $_";
			}
		}
	}
}

sub z80asm {
	my($source, $options) = @_;
	$options //= "-b -l";
	
	spew("test.asm", $source);
	run("z80asm $options test.asm");
}

sub ticks {
	my($source) = @_;
	z80asm($source);
	run("ticks test.bin -output test.out", 0, "IGNORE");
	my $bin = slurp("test.out");
	my @mem = map {ord} split //, substr($bin, 0, 0x10000);
	my @regs = map {ord} split //, substr($bin, 0x10000);
	return [\@mem, \@regs];
}

1;
