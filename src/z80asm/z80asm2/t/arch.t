#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

append_out("ARCH ok");
path("$test.asm")->spew(<<END);
		nop
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zx81 $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("ARCH ok");
path("$test.asm")->spew(<<END);
		nop
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("ARCH error");
path("$test.asm")->spew(<<END);
		nop
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +XXX $test.asm >> $test.out 2>&1");
append_out("\n");


run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
