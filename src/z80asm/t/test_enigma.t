#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2018
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Compile enigma.c for CPM and run it under a CPM emulator

use strict;
use warnings;
use v5.10;
use Test::More;
use Path::Tiny;
require './t/testlib.pl';

my $NUL 	= ($^O eq 'MSWin32') ? 'nul:' : '/dev/null';
my $CPM_DIR     = '../../ext/cpm';
my $CPM         = '../../ext/cpm/cpm';
my $ENIGMA      = '../../examples/console/enigma.c';

my $cmd = "make -C $CPM_DIR";
run($cmd, 0, 'IGNORE', '');

$cmd = "zcc +cpm -oenigma.com $ENIGMA";
run($cmd, 0, 'IGNORE', '');

spew("enigma.in", "HELLO.\r\n");
spew("enigma.exp", "Enter text to be (de)coded, finish with a .\n".
                   "HREXLSLEOC .");

$cmd = "$CPM enigma < enigma.in > enigma.out 2> $NUL";
ok 0==system($cmd), $cmd;

# cleanup output
my $output = path('enigma.out')->slurp_raw;
for ($output) {
    1 while s/.\x08//g;
    s/\r\n|\n\r/\n/g;
    s/^\s+//s;
}
spew('enigma.out', $output);

ok path('enigma.exp')->slurp_raw eq path('enigma.out')->slurp_raw ,
        "enigma.out and enigma.exp equal";

if (Test::More->builder->is_passing) {
    unlink qw( enigma.com enigma.in enigma.out enigma.exp );
}

unlink_testfiles();
done_testing();
