#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

path("$test.asm")->spew(<<END);
	include "$test.inc"
	include '$test.inc' error
	include error
END

path("$test.inc")->spew(<<END);
	include "$test.2.inc"
END

run_nok("$exec -E $test.asm > $test.out 2>&1");
run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
