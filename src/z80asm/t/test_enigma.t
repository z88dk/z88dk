#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Compile enigma.c and run it under ticks

# build for ticks
run_ok("zcc +test -o${test}.bin ../../examples/console/enigma.c");

# run with ticks
spew("${test}.in",  "HELLO.\n");
my $expected = "Enter text to be (de)coded, finish with a .\n".
			   "HREXLSLEOC .\n";

run_ok("z88dk-ticks ${test}.bin < ${test}.in > ${test}.out");

# cleanup output
my $output = slurp("${test}.out");
$output =~ s/^Ticks:\s*\d+\s*//m;
spew("${test}.out2", $output);

check_text_file("${test}.out2", $expected);

unlink_testfiles;
done_testing;
