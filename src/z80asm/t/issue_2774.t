#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Support C/C++ style comments in assembler code (Issue #2774)

spew("$test.asm", <<'END');
;comment
//comment
defb 1;comment
defb 2//comment
#define X 3//comment
defb X:defb X+1\defb X+2;comment
defb 6:defb 7\defb 8//comment
END


capture_ok("z88dk-z80asm -b $test.asm", "");
check_bin_file("$test.bin", bytes(1..8));

unlink_testfiles;
done_testing;
