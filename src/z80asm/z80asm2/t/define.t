#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

append_out("DEFINE ok");
path("$test.asm")->spew(<<END);
	define one,two=12/6,three=9/3
END

run_ok("$exec -v -E -Dum,dois=12/6,tres=9/3 $test.asm >> $test.out 2>&1");
run_ok("$exec -v -Dum,dois=12/6,tres=9/3 $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DEFINE error");
path("$test.asm")->spew(<<END);
	define 
	define 27
	define hello hello
	define world,
	define helloworld=2*
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v $test.asm >> $test.out 2>&1");
append_out("\n");


run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
