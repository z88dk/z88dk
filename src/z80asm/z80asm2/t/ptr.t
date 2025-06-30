#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

append_out("PTR ok");
path("$test.asm")->spew(<<END);
		defp	1,2,1193046
		dp		1,2,1193046
		ptr		1,2,1193046
		ptr 	\$,\$,\$
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("PTR errors");
path("$test.asm")->spew(<<END);
		defp 	1+
		dp	 	1,
		ptr 	,
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v $test.asm >> $test.out 2>&1");
append_out("\n");


run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
