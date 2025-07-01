#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

append_out("DEFGROUP ok");
path("$test.asm")->spew(<<END);
		defgroup { x1, x2, x3 }
		defb x1, x2, x3
END
run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DEFGROUP ok");
path("$test.asm")->spew(<<END);
		defgroup 
		
		{ 
		
		x1=1, 
		x2, 
		x3 
		
		}
		defb x1, x2, x3
END
run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DEFGROUP ok");
path("$test.asm")->spew(<<END);
		defgroup 
		
		{ 
		
		x1=1
		x2
		x3 
		
		}
		defb x1, x2, x3
END
run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DEFGROUP error");
path("$test.asm")->spew(<<END);
		defgroup { 
		x1=1 x2 
		}
END
run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v $test.asm >> $test.out 2>&1");
append_out("\n");


run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
