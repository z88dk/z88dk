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

my $test_nr = 0;

for my $reg (qw( BC DE HL SP )) {
	for my $carry (0, 1) {
		for my $base (0x1000, 32768, 32769) {
			for my $sub (0x1000, 32768, 32769) {
				$test_nr++;
				note "Test $test_nr reg=$reg F_C=$carry base=$base sub=$sub";
				
				my $init_carry = $carry ? "scf" : "and a";
				my $base1 = ($reg eq 'HL') ? $sub : $base;
				my $sum = $base1 - $sub;
								
				$ticks->add(<<END, 
						$init_carry 
						ld		hl, $base
						ld		$reg, $sub
						sub 	hl, $reg
END
				F_C => $sum < 0 ? 1 : 0,
				HL  => $sum < 0 ? $sum + 65536 : $sum);
			}
		}
	}
}

$ticks->run;

unlink_testfiles();
done_testing();
