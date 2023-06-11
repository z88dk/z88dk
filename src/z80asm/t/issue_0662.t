#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/662
# z80asm: ALIGN directive not working inside PHASE

z80asm_ok("", "", "", <<END, bytes(1, (0) x 15, 2));
	defb 1
	align 16
	defb 2
END

z80asm_ok("", "", "", <<END, bytes(1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6, 2));
	defb 1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6
	align 16
	defb 2
END

SKIP: {
	skip "align disregards org", 1;
	
	z80asm_ok("-b -r2", "", "", <<END, bytes(1, (0) x 13, 2));
		defb 1
		align 16
		defb 2
END
}

z80asm_ok("", "", "", <<END, bytes(1, 2, 3, (0) x 14, 4));
	defb 1
	phase 0x8000
	defb 2,3
	align 16
	defb 4
END


unlink_testfiles;
done_testing;
