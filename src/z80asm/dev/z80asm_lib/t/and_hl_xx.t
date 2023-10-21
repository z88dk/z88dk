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

for my $reg (qw( de )) {
	for my $a (0, 0xAAAA) {
		for my $b (0x5555, 0xFFFF) {
			note "reg:$reg a:$a b:$b";

			$ticks->add(<<END, HL=>$a & $b);
						ld		hl, $a
						ld		$reg, $b
						and		hl, $reg
END
		}
	}
}

$ticks->run;

unlink_testfiles();
done_testing();
