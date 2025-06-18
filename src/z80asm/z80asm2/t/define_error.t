#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

path("$test.asm")->spew(<<END);
	define 
	define 27
	define hello hello
	define world,
	define helloworld=2*
END

run_ok("$exec -E $test.asm > $test.out 2>&1");
run_nok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
