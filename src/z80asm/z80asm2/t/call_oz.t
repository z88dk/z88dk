#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

append_out("CALL_OZ ok");
path("$test.asm")->spew(<<END);
		call_oz 1
		call_oz 255
		call_oz 256
		call_oz 65535
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +z88 $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("CALL_OZ illegal");
run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("CALL_OZ range");
path("$test.asm")->spew(<<END);
		call_oz 0
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +z88 $test.asm >> $test.out 2>&1");
append_out("\n");


run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
