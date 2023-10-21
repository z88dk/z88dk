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

# RLD / RRD
for my $carry (0, 1) {
	for my $op (qw( rld rrd )) {
		for my $a (0x12, 0xF2, 0x01) {
			for my $data (0x34, 0x01) {
				$test_nr++;
				my $data_label = "L${test_nr}_data";
				
				my $bc = 0x8765;
				my $de = 0x4321;
				my $init_carry = $carry ? "scf" : "and a";
				my $exp_a = ($a & 0xF0) | 
							($op eq 'rld' ? ($data >> 4) & 0x0F 
										  : $data & 0x0F);
				my $exp_data = $op eq 'rld' ? 
					(($data << 4) & 0xF0) | ($a & 0x0F) : 
					(($data >> 4) & 0x0F) | (($a << 4) & 0xF0);
				
				$ticks->add(<<END, 
							jp start
					data:	defb -1
					start:
							$init_carry
							ld bc, $bc
							ld de, $de

							ld hl, data
							ld (hl), $data
							ld a, $a
							
							$op
END
					A    => $exp_a,
					F_S  => ($exp_a & 0x80	? 1 : 0),
					F_Z  => ($exp_a == 0 		? 1 : 0),
					F_H  => 0,
					F_PV => parity($exp_a),
					F_N  => 0,
					F_C  => $carry,
					BC   => $bc,
					DE   => $de,
					HL   => sub { my($t) = @_;
								local $Test::Builder::Level = $Test::Builder::Level + 1;
								my $data_addr = $t->{labels}{$data_label};
								is $t->{mem}[$data_addr], $exp_data, "data";
								return $data_addr; });
			}
		}
	}
}

$ticks->run;

unlink_testfiles();
done_testing();
