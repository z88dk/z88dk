#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# https://github.com/z88dk/z88dk/issues/243
# accept .rel files as input to the assembler

# build the example
run_ok("make -C t/243");

unlink_testfiles;
done_testing;
