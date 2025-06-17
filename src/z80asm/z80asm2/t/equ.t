#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

path("$test.asm")->spew(<<END);
	; equ
	.v1 equ 10:v2: equ 20\\v3 equ 30
.start
v4 equ +start
END

run_nok("$exec $test.asm > $test.out 2>&1");
run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
