#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

append_out("INCLUDE ok");
path("$test.asm")->spew(<<END);
	nop
	include "$test.inc"
	nop
	include './$test.inc'
	nop
	include '.\\$test.inc'
	nop
	include "./$test.inc"
	nop
	include ".\\$test.inc"
	nop
END

path("$test.inc")->spew(<<END);
	nop
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("INCLUDE error");
path("$test.asm")->spew(<<END);
	include "$test.inc"
	include '$test.inc' error
	include error
END

path("$test.inc")->spew(<<END);
	include "$test.2.inc"
END

run_nok("$exec -E $test.asm >> $test.out 2>&1");
append_out("\n");


run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
