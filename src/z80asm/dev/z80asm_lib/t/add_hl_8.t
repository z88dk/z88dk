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

for my $reg (qw( BC DE HL )) {
	for my $base (0, 255, 65534) {
		for my $add (1, 2) {
			note "reg:$reg base:$base add:$add";

			my $sum = $base + $add;
			
			# z80n does not update carry, neither does emulation
			$ticks->add(<<END, $reg=>$sum);
					ld		$reg, $base
					ld		a, $add
					
					add 	$reg, a
END
		}
	}
}

$ticks->run;

unlink_testfiles();
done_testing();
