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
use Test::Cmd::Common;

# run z80asm2 from .
$ENV{PATH} = ".".$Config{path_sep}.$ENV{PATH};

sub norm_nl { local $_ = shift; s/\r\n/\n/g; return $_; }

my $test = Test::Cmd::Common->new(
	string => "error tests", 
	prog => "z80asm2", workdir => '');

sub error {
	my($asm, $error) = @_;
	$test->write("test.asm", $asm);
	unlink "test.bin";
	$test->run(args => "test.asm", fail => '$? == 0', stdout => "", stderr => undef);
	is norm_nl($test->stderr), $error, "stderr";
	my $ok = !-f "test.bin";
	ok $ok, "test.bin not created";
}

# syntax error - no output binary
error("ld", "Error at test.asm line 1: Syntax error\n");
done_testing();
