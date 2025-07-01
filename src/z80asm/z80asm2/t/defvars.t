#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

append_out("DEFVARS ok");
path("$test.asm")->spew(<<END);
		defvars 16384 {
			v1    	ds.b 1          ; v1 = 0x4000
			v2    	ds.b 3          ; v2 = 0x4001
			v3    	ds.w 1          ; v3 = 0x4004
					ds.w 1          ; reserve one word
		}
		
		defvars 0               	; stand-alone struct
		{
			prev  	ds.w 1          ; prev = 0
			next  	ds.w 1          ; next = 2
			data  	ds.w 1          ; data = 4
		}
		
		defvars -1              	; continue 0x4000 struct
		{
			v4    	ds.q 1          ; v4 = 0x4008
		}
		
		defw v1, v2, v3, v4
		defw prev, next, data
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DEFVARS error");
path("$test.asm")->spew(<<END);
		defvars {
		defvars 0 {
			xx.w 1
		}
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v $test.asm >> $test.out 2>&1");


run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
