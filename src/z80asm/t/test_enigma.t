#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2022
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Compile enigma.c and run it under ticks

use Modern::Perl;
use Test::More;
use Path::Tiny;
require './t/testlib.pl';

my $NUL 		= ($^O eq 'MSWin32') ? 'nul' : '/dev/null';

# build for ticks
my $cmd = "zcc +test -oenigma.bin ../../examples/console/enigma.c";
ok 0==system($cmd), $cmd;

if (Test::More->builder->is_passing) {
	# run with ticks
	spew("enigma.in", "HELLO.\n");
	spew("enigma.exp", "Enter text to be (de)coded, finish with a .\n".
					   "HREXLSLEOC .\n");

	$cmd = "z88dk-ticks enigma.bin < enigma.in > enigma.out 2> $NUL";
	ok 0==system($cmd), $cmd;

	# cleanup output
	my $output = path('enigma.out')->slurp_raw;
	for ($output) {
		s/^Ticks:\s*\d+\s*//m;
		s/\r\n/\n/g;
	}
	spew('enigma.out', $output);

	ok path('enigma.exp')->slurp_raw eq path('enigma.out')->slurp_raw ,
			"enigma.out and enigma.exp equal";
	
    unlink qw( enigma.bin enigma.com enigma.in enigma.out enigma.exp );
}

unlink_testfiles();
done_testing();
