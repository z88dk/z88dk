#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

append_out("CPU ok");
path("$test.asm")->spew(<<END);
		nop
END

run_ok("$exec -mz180 -E $test.asm >> $test.out 2>&1");
run_ok("$exec -mz180 -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("CPU error");
run_nok("$exec -mz180x -E $test.asm >> $test.out 2>&1");
append_out("\n");


run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
