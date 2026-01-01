#!/usr/bin/env perl

#------------------------------------------------------------------------------
# z80asm assembler
# Test z88dk-z80asm-*.lib
# Copyright (C) Paulo Custodio, 2011-2026
# License: http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------

BEGIN { use lib '../../t'; require 'testlib.pl'; }

use Modern::Perl;

my $ticks = Ticks->new;

for my $op ('rdel', 'rlde', 'rl de') {
	for my $carry (0, 1) {
		for my $base (0x5555, 0xaaaa) {
			note "carry:$carry base:$base";

			my $init_carry = $carry ? "scf" : "and a";
			my $res = ($base << 1) | $carry;
			
			$ticks->add(<<END, F_C=>($base & 0x8000) ? 1 : 0, DE=>$res);
					ld		de, $base
					$init_carry 
					$op
END
		}
	}
}

$ticks->run;

unlink_testfiles();
done_testing();
