#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/194
# z80asm: wrong assembly of DDCB with no index

z80asm_ok("-b -s -l", "", "", <<'END', bytes((0xDD, 0xCB, 0x00, 0x06) x 2));
	rlc (ix+0)
	rlc (ix)
END

unlink_testfiles;
done_testing;
