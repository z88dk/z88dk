#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Compile enigma.c for CPM and run it under a CPM emulator

use Modern::Perl;
use Test::More;
use Path::Tiny;
require './t/testlib.pl';

my $NUL 		= ($^O eq 'MSWin32') ? 'nul' : '/dev/null';
my $CPM_DIR     = '../../ext/cpm';
my $CPM         = '../../ext/cpm/cpm';
my $TICKS_DIR	= '../ticks';
my $TICKS		= '../ticks/z88dk-ticks';
my $ENIGMA      = '../../examples/console/enigma.c';

# build CP/M
my $cmd = "make -C $CPM_DIR";
ok 0==system($cmd), $cmd;

# build for CP/M
$cmd = "zcc +cpm -oenigma.com $ENIGMA";
ok 0==system($cmd), $cmd;

if (Test::More->builder->is_passing) {
	# run with CP/M
	spew("enigma.in", "HELLO.\r\n");
	spew("enigma.exp", "Enter text to be (de)coded, finish with a .\n".
					   "HREXLSLEOC .");

	$cmd = path($CPM)->canonpath." enigma < enigma.in > enigma.out 2> $NUL";
	ok 0==system($cmd), $cmd;

	# cleanup output
	my $output = path('enigma.out')->slurp_raw;
	for ($output) {
		1 while s/.\x08//g;
		s/[\r\n]+/\n/g;
		s/^\s+//s;
	}
	spew('enigma.out', $output);

	ok path('enigma.exp')->slurp_raw eq path('enigma.out')->slurp_raw ,
			"enigma.out and enigma.exp equal";

    unlink qw( enigma.bin enigma.com enigma.in enigma.out enigma.exp );
}

# build ticks
$cmd = "make -C $TICKS_DIR";
ok 0==system($cmd), $cmd;

# build for ticks
$cmd = "zcc +test -oenigma.bin $ENIGMA";
ok 0==system($cmd), $cmd;

if (Test::More->builder->is_passing) {
	# run with ticks
	spew("enigma.in", "HELLO.\n");
	spew("enigma.exp", "Enter text to be (de)coded, finish with a .\n".
					   "HREXLSLEOC .\n");

	$cmd = path($TICKS)->canonpath." enigma.bin < enigma.in > enigma.out 2> $NUL";
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
