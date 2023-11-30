#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# BUG_0047 : Expressions including ASMPC not relocated - impacts call po|pe|p|m emulation in RCM2000
z80asm_ok("-r0x100 -b", "", "", <<END, bytes(0,1,0,1,0,1, 0xc3,6,1));
			bug0047a:
				defw	ASMPC,ASMPC,ASMPC	;; 00 01 00 01 00 01
			bug0047b:	
				jp		ASMPC				;; C3 06 01
END

unlink_testfiles;
done_testing;
