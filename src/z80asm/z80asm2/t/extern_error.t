#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

path("$test.asm")->spew(<<END);
	extern func1
func1:
func2:
	extern func2,func3
	extern ,
	extern func4=2
END

run_ok("$exec -E $test.asm > $test.out 2>&1");
run_nok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
