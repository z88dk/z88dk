#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

append_out("No ALIGN, no filler\n");
path("$test.asm")->spew(<<END);
		ld a,1
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("section ALIGN, no filler\n");
path("$test.asm")->spew(<<END);
		align 8
		ld a,1
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("double section ALIGN\n");
path("$test.asm")->spew(<<END);
		align 8
		align 8
		ld a,1
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("section ALIGN, with filler\n");
path("$test.asm")->spew(<<END);
		align 8, 255
		ld a,1
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("code ALIGN, no filler\n");
path("$test.asm")->spew(<<END);
		ld a,1
		align 8
		ld a,2
		align 8
		align 8
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");



append_out("code ALIGN, filler\n");
path("$test.asm")->spew(<<END);
		ld a,1
		align 8,255
		ld a,2
		align 8,170
		align 8,255
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("code ALIGN, filler in options\n");
path("$test.asm")->spew(<<END);
		ld a,1
		align 8
		ld a,2
		align 8,170
		align 8
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v -f255 $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("ORG and ALIGN not aligned");
path("$test.asm")->spew(<<END);
		align 4
		org 3
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("ORG and ALIGN not aligned");
path("$test.asm")->spew(<<END);
		org 3
		align 4
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("ORG and ALIGN not aligned");
path("$test.asm")->spew(<<END);
		align 4
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v -r3 $test.asm >> $test.out 2>&1");
append_out("\n");



run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
