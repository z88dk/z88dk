#!/usr/bin/env perl

#------------------------------------------------------------------------------
# z80asm assembler
# Test z88dk-z80asm-*.lib
# Copyright (C) Paulo Custodio, 2011-2024
# License: http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------

BEGIN { use lib '../../t'; require 'testlib.pl'; }

use Modern::Perl;

my $ticks = Ticks->new;

for my $carry (0, 1) {
	for my $base (0, 255, 32767, 0xffff) {
		for my $add (0, 1, 0x7f, 0x80, 0xff) {
			for my $op ("ldsi $add", "adi sp, $add", "ld de, sp+$add") {
				my $init_carry = $carry ? "scf" : "and a";
				my $res = $base + $add;
				
				$ticks->add(<<END, F_C=>($res > 0xffff) ? 1 : 0, SP=>$base, DE=>$res);
						ld		sp, $base
						$init_carry 
						$op
END
			}
		}
	}
}

$ticks->run;

unlink_testfiles();
done_testing();
