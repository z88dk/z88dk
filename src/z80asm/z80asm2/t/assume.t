#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

append_out("ASSUME ok");
path("$test.asm")->spew(<<END);
	; .ASSUME
	.Assume 3*0:.Assume 3/3
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("ASSUME error");
path("$test.asm")->spew(<<END);
	; .ASSUME
	.Assume ASMPC*25:.Assume \$/2
END

run_nok("$exec $test.asm >> $test.out 2>&1");
append_out("\n");


run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
