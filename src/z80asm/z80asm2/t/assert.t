#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

append_out("ASSERT ok\n");
path("$test.asm")->spew(<<END);
		assert 1
		nop
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("ASSERT failure\n");
path("$test.asm")->spew(<<END);
		assert 0
		nop
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("ASSERT failure with message\n");
path("$test.asm")->spew(<<END);
		assert 0, "this cannot work"
		nop
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("ASSERT ok with define\n");
path("$test.asm")->spew(<<END);
		assert HAS_ASSERT
		nop
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v -DHAS_ASSERT $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("ASSERT failure with define\n");
path("$test.asm")->spew(<<END);
		assert HAS_ASSERT
		nop
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("ASSERT failure with define and message\n");
path("$test.asm")->spew(<<END);
		assert HAS_ASSERT, "does not have assert"
		nop
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v $test.asm >> $test.out 2>&1");
append_out("\n");








run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
