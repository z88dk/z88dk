#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

append_out("BYTE ok");
path("$test.asm")->spew(<<END);
		defb 	1,2,3,4,"hello",32,"world",0
		db	 	1,2,3,4,"hello",32,"world",0
		defm 	1,2,3,4,"hello",32,"world",0
		dm	 	1,2,3,4,"hello",32,"world",0
		byte 	1,2,3,4,"hello",32,"world",0
		byte 	\$,\$,\$,\$,\$,\$,\$,\$,\$,\$,\$,\$,\$,\$,\$,\$
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("BYTE errors");
path("$test.asm")->spew(<<END);
		defb 	1+
		db	 	1,
		defm 	,
		dm	 	"hello"+3
		byte 	+"world"
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v $test.asm >> $test.out 2>&1");
append_out("\n");


run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
