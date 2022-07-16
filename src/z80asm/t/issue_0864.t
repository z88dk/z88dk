#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

z80asm_ok("", "", "", <<'END', "Requires Core v14010".bytes(0xa0));
		defl CORE_VERSION = 14010
		defm "Requires Core v"
		reptc char, CORE_VERSION
		  defb char
		endr
		defm ' '+0x80
END

unlink_testfiles;
done_testing;
