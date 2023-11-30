#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# test BUG_0038: library modules not loaded in sequence
# obj1 requires libobj7 and obj3;
# obj2 requires libobj6 and obj3;
# obj3 requires libobj5 and obj1;
# libobj5 requires libobj6;
# libobj6 requires libobj7;
# libobj7 requires libobj5;

spew("${test}.asm", <<END);
	PUBLIC A1
	EXTERN A3
	EXTERN A7
A1:	defb 1,A7,A3	; A1 at addr 0, len 3
END

spew("${test}2.asm", <<END);
	PUBLIC A2
	EXTERN A3
	EXTERN A6
A2:	defb 2,A6,A3	; A2 at addr 3, len 3
END

spew("${test}3.asm", <<END);
	PUBLIC A3
	EXTERN A1
	EXTERN A5
A3:	defb 3,A5,A1	; A3 at addr 6, len 3
END

spew("${test}5.asm", <<END);
	PUBLIC A5
	EXTERN A6
A5:	defb 5,A6		; A5 at addr 9, len 2
END

spew("${test}6.asm", <<END);
	PUBLIC A6
	EXTERN A7
A6:	defb 6,A7		; A6 at addr 11, len 2
END

spew("${test}7.asm", <<END);
	PUBLIC A7
	EXTERN A5
A7:	defb 7,A5		; A7 at addr 13, len 2
END

capture_ok("z88dk-z80asm -x${test}5.lib ${test}5.asm", ""); 
ok -f "${test}5.lib";
capture_ok("z88dk-z80asm -x${test}6.lib ${test}6.asm", ""); 
ok -f "${test}6.lib";
capture_ok("z88dk-z80asm -x${test}7.lib ${test}7.asm", ""); 
ok -f "${test}7.lib";

capture_ok("z88dk-z80asm -l -m -b -l${test}5.lib -l${test}6.lib -l${test}7.lib ".
				 "${test}.asm ${test}2.asm ${test}3.asm", "");

ok -f "${test}.bin";
check_bin_file("${test}.bin", 
		bytes(	1, 13, 6,
				2, 11, 6,
				3,  9, 0,
				5, 11, 
				6, 13,
				7,  9,
			));


unlink_testfiles;
spew("${test}.asm", <<END);
	EXTERN abs
	call abs
END

spew("${test}2.asm", <<END);
	PUBLIC abs
abs:ld a,1
	ret
END

spew("${test}5.asm", <<END);
	PUBLIC abs
abs:ld a,2
	ret
END

capture_ok("z88dk-z80asm -x${test}5.lib ${test}5.asm", ""); 
ok -f "${test}5.lib";

capture_ok("z88dk-z80asm -l -m -b -l${test}5.lib ${test}.asm ${test}2.asm", "");
ok -f "${test}.bin";
check_bin_file("${test}.bin", 
		bytes(	0xCD, 3, 0,
				0x3E, 1,
				0xC9
			));

unlink_testfiles;
done_testing;

