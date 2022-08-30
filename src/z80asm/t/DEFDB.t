#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

for my $defdb (qw(defdb ddb)) {
	ok 1, "Test with $defdb";

	z80asm_nok("", "", "xx: $defdb", <<END_ERR);
$test.asm:1: error: syntax error
  ^---- xx: $defdb
END_ERR

	z80asm_nok("", "", "xx: $defdb xx,", <<END_ERR);
$test.asm:1: error: syntax error
  ^---- xx: $defdb xx,
END_ERR

	z80asm_ok("", "", "", "xx: $defdb xx" 				=> bytes(0,0));
	z80asm_ok("", "", "", "xx: $defdb xx,xx+1,255,256" 	=> bytes(0,0, 0,1, 0,255, 1,0));
}

unlink_testfiles;
done_testing;
