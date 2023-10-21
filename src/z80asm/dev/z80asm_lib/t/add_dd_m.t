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

for my $reg (qw( bc de hl )) {
	for my $base (0, 255, 65534) {
		for my $add (1, 2) {
			note "reg:$reg base:$base add:$add";
			my $sum = $base + $add;
			my $carry = $sum > 65535 ? 1 : 0;
			my $set_carry = $carry ? "scf" : "and a";
			
			$ticks->add(<<END, F_C=>$carry, HL=>$sum);
					ld		$reg, $base
					add 	$reg, $add
					
					push 	$reg
					pop		hl
					
					; z80n does not update carry
					IF __CPU_Z80N__
					$set_carry
					ENDIF
END
		}
	}
}

$ticks->run;

unlink_testfiles();
done_testing();
