#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/577
# z80asm: Ti83 and Ti83 apps can't be compiled

z80asm_ok("", "", "", <<END, bytes(1, 2));
		defc    Lo      = 1
		defc    Lz      = 2
		
		defb 	Lo, Lz
END

for my $cpu (qw( r2ka r3k )) {
	z80asm_ok("-b -m$cpu", "", "", <<END, bytes(0xE2, 0,0, 0xEA, 0,0));
		jp Lz, 0
		jp Lo, 0
END
}

unlink_testfiles;
done_testing;
