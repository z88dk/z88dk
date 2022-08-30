#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

for my $defw (qw(defw dw word)) {
	ok 1, "Test with $defw";

	z80asm_nok("", "", "xx: $defw", <<END_ERR);
$test.asm:1: error: syntax error
  ^---- xx: $defw
END_ERR

	z80asm_nok("", "", "xx: $defw xx,", <<END_ERR);
$test.asm:1: error: syntax error
  ^---- xx: $defw xx,
END_ERR

	z80asm_ok("", "", "", "xx: $defw xx" 			=> words(0));
	z80asm_ok("", "", "", "xx: $defw xx,xx+102h" 	=> words(0, 0x102));
}

unlink_testfiles;
done_testing;
