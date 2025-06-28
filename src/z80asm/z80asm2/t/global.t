#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

append_out("GLOBAL ok");
path("$test.asm")->spew(<<END);
	jp func1
	global func1
	global func1
	global func2,func3
	global func2,func3
func2:
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("GLOBAL error");
path("$test.asm")->spew(<<END);
	global func1
	extern func1
	
	global func2
	public func2
	
	extern func3
	global func3
	
	public func4
	global func4

	global ,
	global func5=2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v $test.asm >> $test.out 2>&1");
append_out("\n");


run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
