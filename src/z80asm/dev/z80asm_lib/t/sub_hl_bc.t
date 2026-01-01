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

for my $op ('dsub', 'sub hl, bc') {
	for my $carry (0, 1) {
		for my $base (0, 32768, 32769) {
			for my $sub (255, 256, 32767, 32768, 32769) {
				note "carry:$carry base:$base sub:$sub";

				my $init_carry = $carry ? "scf" : "and a";
				my $res = $base - $sub;
				
				$ticks->add(<<END, F_C=>($res < 0 ? 1 : 0), HL=>$res, BC=>$sub);
						ld		hl, $base
						ld		bc, $sub
						$init_carry 
						sub 	hl, bc
END
			}
		}
	}
}

$ticks->run;

unlink_testfiles();
done_testing();
