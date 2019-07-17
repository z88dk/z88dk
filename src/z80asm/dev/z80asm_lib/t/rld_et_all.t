#------------------------------------------------------------------------------
# Z88DK Z80 Macro Assembler
#
# Test z80asm-*.lib
#
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------
use strict;
use warnings;
use v5.10;
use Test::More;
require '../../t/testlib.pl';

# CPUs not supported by ticks: z80n z180 r3k
my @CPUS = (qw( z80 r2k ));
my $test_nr;

# RLD / RRD
for my $cpu (@CPUS) {
	for my $carry (0, 1) {
		for my $op (qw( rld rrd )) {
			for my $a (0x12, 0xF2, 0x01) {
				for my $data (0x34, 0x01) {
					my $bc = 0x8765;
					my $de = 0x4321;
					$test_nr++;
					note "Test $test_nr: cpu:$cpu, carry:$carry, a:$a, data:$data, op:$op";
					my $carry_set = $carry ? "scf" : "and a";
					my $r = ticks(<<END, "-m$cpu");
						defc data = 0x100
								$carry_set
								ld bc, $bc
								ld de, $de

								ld hl, data
								ld (hl), $data
								ld a, $a
								
								$op
								
								rst 0
END
					my $exp_a = ($a & 0xF0) | 
								($op eq 'rld' ? ($data >> 4) & 0x0F 
											  : $data & 0x0F);
					my $exp_data = $op eq 'rld' ? 
						(($data << 4) & 0xF0) | ($a & 0x0F) : 
						(($data >> 4) & 0x0F) | (($a << 4) & 0xF0);

					is $r->{A}, $exp_a, 						"A";
					is $r->{mem}[0x100], $exp_data,				"(HL)";
					
					is $r->{F_S}, ($exp_a & 0x80	? 1 : 0), 	"S";
					is $r->{F_Z}, ($exp_a == 0 		? 1 : 0), 	"Z";
					is $r->{F_H}, 0,						 	"Hf";
					is $r->{F_PV}, parity($exp_a),			 	"PV";
					is $r->{F_N}, 0,						  	"N";
					is $r->{F_C}, $carry,					  	"C";
					is $r->{BC}, $bc,							"BC";
					is $r->{DE}, $de,							"DE";
						
					# die if $test_nr == 73;
				}
			}
		}
	}
}

unlink_testfiles();
done_testing();
