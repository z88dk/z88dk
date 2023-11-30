#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# BUG_0035 : Symbol not defined in forward references
z80asm_ok("", "", "", <<END, bytes(0xcd,6,0, 0xcd,6,0, 0xc9));
			call loop			;; CD 06 00
			call loop 			;; CD 06 00
		loop:
			ret					;; C9
END

unlink_testfiles;
done_testing;
