#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

path("$test.1.asm")->spew(<<END);
	public func1
	public func2,func3
END
path("$test.2.asm")->spew(<<END);
	public ,
	public func4=2
END

run_ok("$exec -E $test.1.asm $test.2.asm > $test.out 2>&1");
run_nok("$exec -v $test.1.asm $test.2.asm >> $test.out 2>&1");
run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
