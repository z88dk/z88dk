#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

path("$test.asm")->spew(<<END);
	nop
	include "$test.inc"
	nop
	include './$test.inc'
	nop
	include '.\\$test.inc'
	nop
	include "./$test.inc"
	nop
	include ".\\$test.inc"
	nop
END

path("$test.inc")->spew(<<END);
	nop
END

run_ok("$exec -E $test.asm > $test.out 2>&1");
run_nok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
