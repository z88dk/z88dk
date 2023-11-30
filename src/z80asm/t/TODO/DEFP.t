#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

for my $defp (qw(defp ptr dp)) {
	ok 1, "Test with $defp";

	z80asm_nok("", "", "xx: $defp", <<END_ERR);
$test.asm:1: error: syntax error
  ^---- xx: $defp
END_ERR

	z80asm_nok("", "", "xx: $defp xx,", <<END_ERR);
$test.asm:1: error: syntax error
  ^---- xx: $defp xx,
END_ERR

	z80asm_ok("", "", "", "xx: $defp xx" 			=> bytes(0,0,0));
	z80asm_ok("", "", "", "xx: $defp xx,xx+10203h" 	=> bytes(0,0,0, 3,2,1));
}

unlink_testfiles;
done_testing;
