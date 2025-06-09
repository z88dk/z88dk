#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

path("$test.asm")->spew(<<END);
	; label
	.l1 ld a,25
	l2:ld a,25
	ld a,25
END

run_ok("$exec -E $test.asm > $test.out 2>&1");
run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
