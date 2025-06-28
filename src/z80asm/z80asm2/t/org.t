#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

append_out("No ORG\n");
path("$test.asm")->spew(<<END);
		nop
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("ORG defined\n");
path("$test.asm")->spew(<<END);
		org 256
		nop
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("ORG doubly defined\n");
path("$test.asm")->spew(<<END);
		org 256
		org 256
		nop
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("Invalid ORG\n");
path("$test.asm")->spew(<<END);
		org -2
		nop
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("ORG in command line\n");
path("$test.asm")->spew(<<END);
		nop
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v -r256 $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("ORG in command line and in code\n");
path("$test.asm")->spew(<<END);
		org 1024
		nop
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v -r256 $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("Section split\n");
path("$test.asm")->spew(<<END);
		section code
		org -1
		nop
		section data
		org -1
		nop
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("invalid ORG in command line\n");
path("$test.asm")->spew(<<END);
		nop
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v -r* $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("invalid ORG in command line\n");
path("$test.asm")->spew(<<END);
		nop
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v -r2+ $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("invalid ORG in command line\n");
path("$test.asm")->spew(<<END);
		nop
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v -r0-1 $test.asm >> $test.out 2>&1");
append_out("\n");


run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
