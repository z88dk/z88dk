#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# create binary file
path("$test.bin")->spew_raw(join('', map {chr} 0..255));

append_out("BINARY ok");

path("$test.asm")->spew(<<END);
	ld a,1
	binary "$test.bin"
	ld a,2
	incbin "$test.bin"
	ld a,3
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("BINARY error");
path("$test.asm")->spew(<<END);
	binary "file that does not exist"
	binary
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec $test.asm >> $test.out 2>&1");
append_out("\n");


run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
