#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# https://github.com/z88dk/z88dk/issues/2132
# z80asm - expression test sets value

spew("$test.asm", <<END);
	defb 0
IF __IO_CF_8_BIT = 1
	defb 1
ENDIF
IF __IO_CF_8_BIT = 1
	defb 2
ENDIF
END

# assemble with constant undefined
capture_ok("z88dk-z80asm -b $test.asm", "");
check_bin_file("$test.bin", bytes(0));

# assemble with constant defined
capture_ok("z88dk-z80asm -D__IO_CF_8_BIT -b $test.asm", "");
check_bin_file("$test.bin", bytes(0, 1, 2));

unlink_testfiles;
done_testing;
