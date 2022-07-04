#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# BUG_0020: Segmentation fault in ParseIdent for symbol not found with interpret OFF
spew("$test.asm", <<END);
		IF CC
		invalid
		ENDIF
		defb 0
END

capture_nok("z88dk-z80asm -b -DCC $test.asm", <<END);
$test.asm:2: error: syntax error
  ^---- invalid
END

run_ok("z88dk-z80asm -b $test.asm");
check_bin_file("$test.bin", bytes(0));

unlink_testfiles;
done_testing;
