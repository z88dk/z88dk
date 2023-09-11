#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

for my $defc (qw(defc dc)) {
	ok 1, "Test with $defc";

	z80asm_nok("", "", "xx: $defc", <<END_ERR);
$test.asm:1: error: syntax error
  ^---- xx: $defc
END_ERR

	z80asm_nok("", "", "xx: $defc aa", <<END_ERR);
$test.asm:1: error: syntax error
  ^---- xx: $defc aa
END_ERR

	z80asm_nok("", "", "xx: $defc aa=", <<END_ERR);
$test.asm:1: error: syntax error
  ^---- xx: $defc aa=
END_ERR

	z80asm_nok("", "", "xx: $defc aa=1+1,", <<END_ERR);
$test.asm:1: error: syntax error
  ^---- xx: $defc aa=1+1,
END_ERR

	z80asm_ok("", "", "", 
		"xx: $defc aa=1+1"				=> "",
		"    $defc bb=2+2,cc=3+3"		=> "",
		"    defb xx,aa,bb,cc"			=> bytes(0, 2, 4, 6));
		
	z80asm_ok("-b -r0x100", "", "", <<END, words(0, 0x100, 0x100, 0x200, 0x400));
		xx:	defw 0
			defc aa=xx
			defc bb=2*aa
			defc cc=2*bb
			defw xx,aa,bb,cc
END
			

}

unlink_testfiles;
done_testing;
