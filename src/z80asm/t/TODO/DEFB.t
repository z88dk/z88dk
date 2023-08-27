#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

for my $defb (qw(defb db defm dm byte)) {
	ok 1, "Test with $defb";

	z80asm_nok("", "", "xx: $defb", <<END_ERR);
$test.asm:1: error: syntax error
  ^---- xx: $defb
END_ERR

	z80asm_nok("", "", "xx: $defb xx,", <<END_ERR);
$test.asm:1: error: syntax error
  ^---- xx: $defb xx,
END_ERR

	z80asm_nok("", "", "xx: $defb \" ", <<END_ERR);
$test.asm:1: error: missing quote
  ^---- xx: $defb "
END_ERR

	z80asm_nok("", "", "xx: $defb ' ", <<END_ERR);
$test.asm:1: error: missing quote
  ^---- xx: $defb '
END_ERR

	z80asm_ok("", "", "", "xx: $defb xx" 		=> bytes(0));
	z80asm_ok("", "", "", "xx: $defb xx, xx+1" 	=> bytes(0, 1));

	# escape chars
	z80asm_ok("", "", "", 
			  'xx: '.$defb.' xx, "\0\1\2", 3' 	=> bytes(0, 0, 1, 2, 3),
			  $defb.' "\a\b\e\f\n\r\t\v"'		=> "\a\b\e\f\n\r\t\x0B",
			  $defb.' "\0\1\2\3\4\5\6\7\10\11\12\376\377"'	
												=> bytes(0..10, 254, 255),
			  $defb.' "\x0\x1\x2\x3\x4\x5\x6\x7\x8\x9\xa\xB\xc\xD\xe\xF\x10\xfe\xFF"'	
												=> bytes(0..16, 254, 255));
}

unlink_testfiles;
done_testing;
