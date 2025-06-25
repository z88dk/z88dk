#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

path("$test.asm")->spew(<<END);
	ld ix, 0
	ld iy, 0
END

unlink "$test.out";
for my $swap ('', '-IXIY', '-IXIY-soft') {
	append_out("swap=$swap\n");
	unlink "$test.o";
	
	run_ok("$exec -E $swap $test.asm >> $test.out 2>&1");
	run_ok("$exec -v $swap $test.asm >> $test.out 2>&1");
	run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
	
	append_out("\n");
}
run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
