#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2466
# z80asm equate definition that is similar to asm opcode instruction causes assembler error message

for my $RLB (".RLB", "RLB", "RLB:") {
	for my $EQU ("equ", "=") {
		spew("$test.asm", <<"END");
$RLB $EQU \$0B95
	defw RLB
END

		capture_ok("z88dk-z80asm -b $test.asm", "");
		check_bin_file("$test.bin", words(0x0b95));
	}
}

unlink_testfiles;
done_testing;



