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

# CPI / CPD
# CPIR / CPDR with BC = 1
for my $cpu (@CPUS) {
	for my $carry (0, 1) {
		for my $data (1, 2, 3) {
			my $a = 2;
			my $de = 0x4321;
			for my $bc (2, 1) {
				for my $op (qw( cpi cpd cpir cpdr )) {
					next if $bc != 1 && $op =~ /cpir|cpdr/;
					$test_nr++;
					note "Test $test_nr: cpu:$cpu, carry:$carry, data:$data, a:$a, bc:$bc, op:$op";
					my $carry_set = $carry ? "scf" : "and a";
					my $r = ticks(<<END, "-m$cpu");
						defc data = 0x100
								$carry_set
								ld de, $de

								ld hl, data
								ld (hl), $data
								ld a, $a
								ld bc, $bc
								
								$op
								
								rst 0
END
					is $r->{F_S}, ($a <  $data 		? 1 : 0), "S";
					is $r->{F_Z}, ($a == $data 		? 1 : 0), "Z";
					is $r->{F_H}, ($a <  $data 		? 1 : 0), "Hf";
					is $r->{F_PV}, ($r->{BC} == 0 	? 0 : 1), "PV";
					is $r->{F_N}, 1,						  "N";
					is $r->{F_C}, $carry,					  "C";					
					is $r->{HL}, $op =~ /cpi/ ? 0x101 : 0x0FF,"HL";
					is $r->{BC}, $bc - 1,					  "BC";
					is $r->{DE}, $de,						  "DE";
					
					# die if $test_nr == 37;
				}
			}
		}
	}
}

# CPIR / CPDR with BC > 1
for my $cpu (@CPUS) {
	for my $carry (0, 1) {
		for my $op (qw( cpir cpdr )) {
			for my $data (1, 2, 3) {
				my $a = 2;
				my $de = 0x4321;
				$test_nr++;
				note "Test $test_nr: cpu:$cpu, carry:$carry, data:$data, a:$a, op:$op";
				my $carry_set = $carry ? "scf" : "and a";
				my $start = $op =~ /cpir/ ? 'data' : 'end-1';
				my $r = ticks(<<END, "-m$cpu");
								jr start
						.data	defs 5, $data
						.end
								
						.start	$carry_set
								ld de, $de

								ld hl, $start
								ld a, $a
								ld bc, end-data
								
								$op
								
								rst 0
END
				is $r->{F_S}, ($a <  $data 		? 1 : 0), 	"S";
				is $r->{F_Z}, ($a == $data 		? 1 : 0), 	"Z";
				is $r->{F_H}, ($a <  $data 		? 1 : 0), 	"Hf";
				is $r->{F_PV}, ($r->{BC} == 0 	? 0 : 1), 	"PV";
				is $r->{F_N}, 1,						  	"N";
				is $r->{F_C}, $carry,					  	"C";
				if ($a == $data) {
					is $r->{HL}, $op =~ /cpir/ ? 0x02+1 
											   : 0x02+5-1-1, "HL";
					is $r->{BC}, 5-1,					  	"BC";
				}
				else {
					is $r->{HL}, $op =~ /cpir/ ? 0x02+5 
											   : 0x02-1,  	"HL";
					is $r->{BC}, 0,						  	"BC";
				}
				is $r->{DE}, $de,							"DE";
					
				# die if $test_nr == 73;
			}
		}
	}
}

unlink_testfiles();
done_testing();
