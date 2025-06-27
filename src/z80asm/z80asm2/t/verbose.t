#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

path("$test.asm")->spew(<<END);
		nop
END

append_out("Options in command line\n");
run_ok("$exec -E -mz180 $test.asm >> $test.out 2>&1");
run_ok("$exec -v -mz180 $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");

append_out("Options in environment\n");
$ENV{Z80ASM} = "-v";
run_ok("$exec -E -mz180 $test.asm >> $test.out 2>&1");
run_ok("$exec -mz180 $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");

run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
