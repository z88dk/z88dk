#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# BUG_0040: Detect and report division by zero instead of crashing
z80asm_nok("", "", <<END, <<END);
		defb 1 / 0
		defb 1 % 0
END
$test.asm:1: error: division by zero
  ^---- 1/0
$test.asm:2: error: division by zero
  ^---- 1% 0
END

unlink_testfiles;
done_testing;
