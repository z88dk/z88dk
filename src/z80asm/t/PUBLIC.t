#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

for my $public (qw( public xdef xlib )) {
	ok 1, "Test with $public";

	z80asm_nok("", "", <<END, <<END);
		$public
END
$test.asm:1: error: syntax error
  ^---- $public
END

spew("$test.asm", <<END);
		$public p1,p2
		$public p3
		$public p4

	p1:	defb ASMPC			;; 00
	p2:	defb ASMPC			;; 01
	p3:	defb ASMPC			;; 02
	p4:	defb ASMPC			;; 03
END

spew("$test.1.asm", <<END);
		extern p1,p2
		extern p3
		extern p4

		defb p1,p2,p3,p4	;; 00 01 02 03
END

run_ok("z88dk-z80asm -b $test.asm $test.1.asm");
check_bin_file("$test.bin", bytes(0x00,
								  0x01,
								  0x02,
								  0x03,
								  0x00, 0x01, 0x02, 0x03));


}

unlink_testfiles;
done_testing;
