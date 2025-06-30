#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

append_out("cu ok");
path("$test.asm")->spew(<<END);
		cu.wait 0,0
		cu.wait 1,0
		cu.wait 311,0
		cu.wait 0,0
		cu.wait 0,1
		cu.wait 0,55
		cu.move 0,0
		cu.move 1,0
		cu.move 127,0
		cu.move 0,0
		cu.move 0,1
		cu.move 0,255
		cu.nop
		cu.stop
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");

run_ok("$exec -v -mz80n $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("cu illegal");
run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("cu range");
path("$test.asm")->spew(<<END);
		cu.wait -1,0
		cu.wait 312,0
		cu.wait 0,-1
		cu.wait 0,56
		cu.move -1,0
		cu.move 128,0
		cu.move 0,-1
		cu.move 0,256
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
