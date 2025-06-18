#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

path("$test.asm")->spew(<<END);
	define one,two=12/6,three=9/3
END

run_ok("$exec -v -E -Dum,dois=12/6,tres=9/3 $test.asm > $test.out 2>&1");
run_nok("$exec -v -Dum,dois=12/6,tres=9/3 $test.asm >> $test.out 2>&1");
run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
