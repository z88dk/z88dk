#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

# BUG_0041: truncate negative powers to zero, i.e. pow(2,-1) == 0
path("$test.1.asm")->spew(<<END);
		public ZERO
		defc ZERO = 0
END

z80asm_ok("-b", "$test.asm $test.1.asm", "", 
q{		extern ZERO			}, bytes(),
q{		defb 2**-1			}, bytes(0),
q{		defb ZERO+2**-1		}, bytes(0),
);

unlink_testfiles;
done_testing;
