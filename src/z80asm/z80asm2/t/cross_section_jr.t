#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

path("$test.asm")->spew(<<END);
		section s1
	x1:	jr x1
		jr x2
		
		section s2
	x2:	jr x1
		jr x2
END

run_ok("$exec -E $test.asm > $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");

run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
