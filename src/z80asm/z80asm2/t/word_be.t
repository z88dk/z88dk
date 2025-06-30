#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

append_out("WORD_BE ok");
path("$test.asm")->spew(<<END);
		defdb 	2,4,8,16,32,64,128,256
		ddb 	\$,\$,\$,\$,\$,\$,\$,\$
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("WORD_BE errors");
path("$test.asm")->spew(<<END);
		defdb 	1+
		ddb 	1,
		defdb 	,
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v $test.asm >> $test.out 2>&1");
append_out("\n");


run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
