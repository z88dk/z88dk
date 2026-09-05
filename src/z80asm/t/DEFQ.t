#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

for my $defq (qw(defq dq dword)) {
	ok 1, "Test with $defq";

	z80asm_nok("", "", "xx: $defq", <<END_ERR);
$test.asm:1: error: syntax error
  ^---- xx: $defq
END_ERR

	z80asm_nok("", "", "xx: $defq xx,", <<END_ERR);
$test.asm:1: error: syntax error
  ^---- xx: $defq xx,
END_ERR

	z80asm_ok("", "", "", "xx: $defq xx" 			=> bytes(0,0,0,0));
	z80asm_ok("", "", "", "xx: $defq xx,xx+1020304h"=> bytes(0,0,0,0, 4,3,2,1));
	# bit 31 set must not clamp to LONG_MAX on LLP64
	z80asm_ok("", "", "", "$defq 0xBE2AAAA3"		=> bytes(0xA3, 0xAA, 0x2A, 0xBE));
	z80asm_ok("", "", "", "$defq 0x80000000"		=> bytes(0, 0, 0, 0x80));
	z80asm_ok("", "", "", "$defq 0xFFFFFFFF"		=> bytes(0xFF, 0xFF, 0xFF, 0xFF));
}

unlink_testfiles;
done_testing;
