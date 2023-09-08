#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

z80asm_nok("", "", <<END, <<END);
		global
END
$test.asm:1: error: syntax error
  ^---- global
END

spew("$test.asm", <<END);
		global g1, g2
		defc g1 = 16, g3 = 48
		global g3, g4
		defb g1, g2, g3, g4	;; 10 20 30 40
END

spew("$test.1.asm", <<END);
		global g1, g2
		defc g2 = 32, g4 = 64
		global g3, g4
		defb g1, g2, g3, g4	;; 10 20 30 40
END

run_ok("z88dk-z80asm -b $test.asm $test.1.asm");
check_bin_file("$test.bin", bytes(0x10, 0x20, 0x30, 0x40,
								  0x10, 0x20, 0x30, 0x40));

unlink_testfiles;
done_testing;
