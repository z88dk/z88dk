#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

z80asm_nok("", "", <<END, <<END);
		extern
		public
		global
		xdef 
		xref 
		xlib 
		lib 	
END
$test.asm:1: error: syntax error
  ^---- extern
$test.asm:2: error: syntax error
  ^---- public
$test.asm:3: error: syntax error
  ^---- global
$test.asm:4: error: syntax error
  ^---- xdef
$test.asm:5: error: syntax error
  ^---- xref
$test.asm:6: error: syntax error
  ^---- xlib
$test.asm:7: error: syntax error
  ^---- lib
END

spew("$test.asm", <<END);
		public	p1,p2
		xdef p3
		xlib p4
		global  g1, g2
		defc g1 = 16, g3 = 48
		global g3, g4

	p1:	defb ASMPC			;; 00
	p2:	defb ASMPC			;; 01
	p3:	defb ASMPC			;; 02
	p4:	defb ASMPC			;; 03
		defb g1, g2, g3, g4	;; 10 20 30 40
END

spew("$test.1.asm", <<END);
		extern 	p1,p2
		xref p3
		lib p4
		global  g1, g2
		defc g2 = 32, g4 = 64
		global g3, g4

		defb p1,p2,p3,p4	;; 00 01 02 03
		defb g1, g2, g3, g4	;; 10 20 30 40
END

run_ok("z88dk-z80asm -b $test.asm $test.1.asm");
check_bin_file("$test.bin", bytes(0x00,
								  0x01,
								  0x02,
								  0x03,
								  0x10, 0x20, 0x30, 0x40,
								  0x00, 0x01, 0x02, 0x03,
								  0x10, 0x20, 0x30, 0x40));

unlink_testfiles;
done_testing;
