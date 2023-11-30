#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# BUG_0011 : ASMPC should refer to start of statememnt, not current element in DEFB/DEFW
z80asm_ok("", "", "",
	"	defb    bug0011a-ASMPC, bug0011a-ASMPC",	bytes(0x06, 0x06),
	"	defb    bug0011a-ASMPC, bug0011a-ASMPC",	bytes(0x04, 0x04),
	"	defb    bug0011a-ASMPC, bug0011a-ASMPC",	bytes(0x02, 0x02),
	"bug0011a:",									bytes(),
);

unlink_testfiles;
done_testing;
