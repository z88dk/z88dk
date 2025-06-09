#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

path("$test.asm")->spew(<<END);
	; .ASSUME
	.Assume ASMPC*0:.Assume \$/\$
END

run_nok("$exec $test.asm > $test.out 2>&1");
run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
