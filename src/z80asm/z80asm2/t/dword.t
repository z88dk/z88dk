#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

append_out("DWORD ok");
path("$test.asm")->spew(<<END);
		defq	305419896,305419896
		dq		305419896,305419896
		dword	305419896,305419896
		defq 	\$,\$
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DWORD errors");
path("$test.asm")->spew(<<END);
		defq 	1+
		dq	 	1,
		dword 	,
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v $test.asm >> $test.out 2>&1");
append_out("\n");


run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
