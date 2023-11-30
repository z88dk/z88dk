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
}

unlink_testfiles;
done_testing;
