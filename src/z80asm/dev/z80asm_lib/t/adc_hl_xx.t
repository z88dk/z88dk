#!/usr/bin/env perl

#------------------------------------------------------------------------------
# z80asm assembler
# Test z88dk-z80asm-*.lib
# Copyright (C) Paulo Custodio, 2011-2023
# License: http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------

BEGIN { use lib '../../t'; require 'testlib.pl'; }

use Modern::Perl;

my $ticks = Ticks->new;

for my $reg (qw( bc de hl sp )) {
	for my $carry (0, 1) {
		for my $base (0, 32768, 32769) {
			for my $add (255, 256, 32767) {
				note "reg:$reg carry:$carry base:$base add:$add";

				my $init_carry = $carry ? "scf" : "and a";
				my $base1 = ($reg eq 'hl') ? $add : $base;
				my $sum = $base1 + $add + $carry;
				
				$ticks->add(<<END, F_C=>($sum > 65535 ? 1 : 0), HL=>$sum);
						ld		hl, $base1
						ld		$reg, $add
						$init_carry 
						adc 	hl, $reg
END
			}
		}
	}
}

$ticks->run;

unlink_testfiles();
done_testing();
