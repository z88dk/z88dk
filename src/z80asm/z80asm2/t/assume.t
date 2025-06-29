#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

for my $cpu ('ez80', 'ez80_strict', 'ez80_z80', 'ez80_z80_strict') {
	append_out("ASSUME ok cpu $cpu");

	path("$test.asm")->spew(<<END);
		.Assume 0
		.Assume 1
		nop
END

	run_ok("$exec -E $test.asm >> $test.out 2>&1");
	run_ok("$exec -v -m$cpu $test.asm >> $test.out 2>&1");
	run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
	append_out("\n");
}

append_out("ASSUME error");
path("$test.asm")->spew(<<END);
	.Assume ASMPC*25:.Assume \$/2
END

run_nok("$exec -mez80 $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("ASSUME error");
path("$test.asm")->spew(<<END);
	.Assume 2
END

run_nok("$exec -mez80 $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("ASSUME error");
path("$test.asm")->spew(<<END);
	.Assume 1
END

run_nok("$exec $test.asm >> $test.out 2>&1");
append_out("\n");


run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
