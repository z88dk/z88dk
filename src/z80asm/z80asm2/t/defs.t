#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

append_out("DEFS no filler\n");
path("$test.asm")->spew(<<END);
		ld a,1
		defs 0
		ld a,2
END
run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DEFS no filler\n");
path("$test.asm")->spew(<<END);
		ld a,1
		defs 1
		ld a,2
END
run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DEFS no filler\n");
path("$test.asm")->spew(<<END);
		ld a,1
		defs 6
		ld a,2
END
run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DEFS filler option\n");
path("$test.asm")->spew(<<END);
		ld a,1
		defs 6
		ld a,2
END
run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v -f255 $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DEFS filler option and argument\n");
path("$test.asm")->spew(<<END);
		ld a,1
		defs 6, 170
		ld a,2
END
run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v -f255 $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DEFS string\n");
path("$test.asm")->spew(<<END);
		ld a,1
		defs 6, ""
		ld a,2
END
run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DEFS string\n");
path("$test.asm")->spew(<<END);
		ld a,1
		defs 6, "hello"
		ld a,2
END
run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DEFS string\n");
path("$test.asm")->spew(<<END);
		ld a,1
		defs 6, "hello!"
		ld a,2
END
run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DEFS string error\n");
path("$test.asm")->spew(<<END);
		ld a,1
		defs 6, "hello!!"
		ld a,2
END
run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DEFS range error\n");
path("$test.asm")->spew(<<END);
		ld a,1
		defs -1
		ld a,2
END
run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DEFS range error\n");
path("$test.asm")->spew(<<END);
		ld a,1
		defs 0,-1
		ld a,2
END
run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DEFS range error\n");
path("$test.asm")->spew(<<END);
		ld a,1
		defs 0,256
		ld a,2
END
run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v $test.asm >> $test.out 2>&1");
append_out("\n");


run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
