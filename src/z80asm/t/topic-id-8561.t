#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# http://www.z88dk.org/forum/viewtopic.php?id=8561
# It looks like a z80asm bug with defc.  
# "DEFC L_DIVENTRY = entry - l_div_u" should result in a small positive
# constant and " l_div_u + L_DIVENTRY" should not evaluate to a large positive
# number or a small negative one.
# Expression evaluator needs to recognize that a subtraction of two
# labels defined in the same module is a constant and not an address.
# Remove '#' operator after this is fixed.

spew("$test.asm", <<END);
		EXTERN l_div

		call l_div					; 0000 ;; CD 04 00
		ret							; 0003 ;; C9
END

spew("$test.1.asm", <<END);
		PUBLIC l_div
		EXTERN l_div_u, L_DIVENTRY
		
	l_div:
		call l_div_u + L_DIVENTRY	; 0004 ;; CD 0D 00
		ret							; 0007 ;; C9
END

spew("$test.2.asm", <<END);
		PUBLIC l_div_u, L_DIVENTRY
		
	l_div_u:
		nop							; 0008 ;; 00
		nop							; 0009 ;; 00
		nop							; 000A ;; 00
		nop							; 000B ;; 00
		nop							; 000C ;; 00
	entry:
		ret							; 000D ;; C9
		
		DEFC L_DIVENTRY = entry - l_div_u
END

run_ok("z88dk-z80asm -b $test.asm $test.1.asm $test.2.asm");
check_bin_file("$test.bin", bytes(	0xCD, 0x04, 0x00,
									0xC9,
									0xCD, 0x0D, 0x00,
									0xC9,
									0x00,
									0x00,
									0x00,
									0x00,
									0x00,
									0xC9));

unlink_testfiles;
done_testing;
