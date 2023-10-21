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
	for my $carry (0, 1) {
		for my $init (0, 0x1111, 0x2222, 0x8888) {
			my $init_carry = $carry ? "scf" : "and a";
			my $res = ($init & 0x8000)|($init >> 1);

			$ticks->add(<<END,
					$init_carry 
					ld		$reg, $init
					sra     $reg
END
				F_C  => ($init & 1) ? 1 : 0,
				$reg => $res);
		}
	}
}

$ticks->run;

unlink_testfiles();
done_testing();
