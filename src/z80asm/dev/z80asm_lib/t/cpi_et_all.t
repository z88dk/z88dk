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

# CPI / CPD
# CPIR / CPDR with BC = 1
my $test_nr = 0;
for my $carry (0, 1) {
	for my $data (1, 2, 3) {
		my $a = 2;
		my $de = 0x4000;
		for my $bc (2, 1) {
			for my $op (qw( cpi cpd cpir cpdr )) {
				next if $bc != 1 && $op =~ /cpir|cpdr/;

				$test_nr++;
				note "Test $test_nr carry:$carry, data:$data, a:$a, bc:$bc, op:$op";
				
				my $set_carry = $carry ? "scf" : "and a";
				my $data_label = "L${test_nr}_data";
				
				$ticks->add(<<END, 
							jr data_end
					data_start: 
							defb 0,0,0,0,0
					data:	defb $data
							defb 0,0,0,0,0
					data_end:

							$set_carry
							ld de, $de
							ld hl, data

							ld a, $a
							ld bc, $bc
							
							$op
END
					F_S	=> $a <  $data ? 1 : 0,
					F_Z	=> $a == $data ? 1 : 0,
					F_H	=> $a <  $data ? 1 : 0,
					F_PV=> ($bc - 1)==0 ? 0 : 1,
					F_N	=> 1,
					F_C	=> $carry,
					HL	=> sub { my($t) = @_;
								 return $op =~ /cpi/ ? $t->{labels}{$data_label}+1 
											         : $t->{labels}{$data_label}-1; },
					BC	=> $bc - 1,
					DE	=> $de);
			}
		}
	}
}

# CPIR with BC > 1
for my $carry (0, 1) {
	for my $data (1, 2, 3) {
		my $a = 2;
		my $de = 0x4000;
		
		$test_nr++;
		note "Test $test_nr: carry:$carry, data:$data, a:$a, op:cpir";
		
		my $set_carry = $carry ? "scf" : "and a";
		my $data_label = "L${test_nr}_data";

		$ticks->add(<<END, 
							jr start
					data_start: 
							defb 0,0,0,0,0
					data:	
							defb $data,$data,$data,$data,$data
					data_end:
							defb 0,0,0,0,0
					start:
							$set_carry
							ld de, $de

							ld hl, data

							ld a, $a
							ld bc, data_end - data
							
							cpir
END
					F_S	=> $a <  $data ? 1 : 0,
					F_Z	=> $a == $data ? 1 : 0,
					F_H	=> $a <  $data ? 1 : 0,
					F_PV=> $a == $data ? 1 : 0,
					F_N	=> 1,
					F_C	=> $carry,
					HL	=> sub { my($t) = @_;
								 return $a == $data ? $t->{labels}{$data_label}+1
													: $t->{labels}{$data_label}+5; },
					BC	=> $a == $data ? 5 - 1 : 0,
					DE	=> $de);
	}
}

# CPDR with BC > 1
for my $carry (0, 1) {
	for my $data (1, 2, 3) {
		my $a = 2;
		my $de = 0x4000;
		
		$test_nr++;
		note "Test $test_nr: carry:$carry, data:$data, a:$a, op:cpdr";
		
		my $set_carry = $carry ? "scf" : "and a";
		my $data_label = "L${test_nr}_data";

		$ticks->add(<<END, 
							jr start
					data_start: 
							defb 0,0,0,0,0
					data:	
							defb $data,$data,$data,$data,$data
					data_end:
							defb 0,0,0,0,0
					start:
							$set_carry
							ld de, $de

							ld hl, data_end - 1

							ld a, $a
							ld bc, data_end - data
							
							cpdr
END
					F_S	=> $a <  $data ? 1 : 0,
					F_Z	=> $a == $data ? 1 : 0,
					F_H	=> $a <  $data ? 1 : 0,
					F_PV=> $a == $data ? 1 : 0,
					F_N	=> 1,
					F_C	=> $carry,
					HL	=> sub { my($t) = @_;
								 return $a == $data ? $t->{labels}{$data_label}+4-1
													: $t->{labels}{$data_label}+4-5; },
					BC	=> $a == $data ? 5 - 1 : 0,
					DE	=> $de);
	}
}

$ticks->run;

unlink_testfiles();
done_testing();
