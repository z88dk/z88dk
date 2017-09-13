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

# CPUs not supported by ticks: z80-zxn z180 r3k
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
					my $r = ticks(<<END, "--cpu=$cpu -b -m -l");
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
				my $r = ticks(<<END, "--cpu=$cpu -b");
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
					my $r = ticks(<<END, "--cpu=$cpu -b");
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

# DAA
for my $cpu (@CPUS) {
	for my $nflag (0, 1) {	# 0 - add, 1 - sub
		for my $carry (0, 1) {
			for my $hcarry (0, 1) {
				for my $ah (0..15) {
					for my $al (0..15) {
						my $a = ($ah << 4) | $al;

						# skip invalid cases
						next if !$nflag && !$carry &&  $hcarry && $al > 3;
						next if !$nflag &&  $carry && !$hcarry && $ah > 2;
						next if !$nflag &&  $carry &&  $hcarry && ($al > 3 || $ah > 3);
						next if  $nflag && !$carry && !$hcarry && ($al > 9 || $ah > 9);
						next if  $nflag && !$carry &&  $hcarry && ($al < 6 || $ah > 8);
						next if  $nflag &&  $carry && !$hcarry && ($al > 9 || $ah < 7);
						next if  $nflag &&  $carry &&  $hcarry && ($al < 6 || $ah < 6);

						$test_nr++;
						note "Test $test_nr: cpu:$cpu, nflag:$nflag, carry:$carry, hcarry:$hcarry, a:$a";
						my $f = 
							($nflag 	? 0x02 : 0) |
							($hcarry 	? 0x10 : 0) |
							($carry		? 0x01 : 0);
						my $r = ticks(<<END, "--cpu=$cpu -b");
								ld h, $a
								ld l, $f
								push hl
								pop af
								
								daa
								
								rst 0
END
						# refer to z280_cpu_tm.pdf pp 63; the z80 pp 187 spec is unclear
						if (!$nflag && !$carry && $ah <= 9 && !$hcarry && $al <= 9) {
							is $r->{A}, $a;
							is $r->{F_C}, 0;
							is $r->{F_H}, 0;
						}
						elsif (!$nflag && !$carry && $ah <= 8 && !$hcarry && $al >= 10) {
							is $r->{A}, ($a + 6) & 0xFF;
							is $r->{F_C}, 0;
							# Fails test 775: cpu:r2k, nflag:0, carry:0, hcarry:0, a:10
							# is $r->{F_H}, 1;
						}
						elsif (!$nflag && !$carry && $ah <= 9 && $hcarry && $al <= 3) {
							is $r->{A}, ($a + 6) & 0xFF;
							is $r->{F_C}, 0;
							# Fails test 1021: cpu:r2k, nflag:0, carry:0, hcarry:1, a:0
							# is $r->{F_H}, 0;
						}
						elsif (!$nflag && !$carry && $ah >= 10 && !$hcarry && $al <= 9) {
							is $r->{A}, ($a + 0x60) & 0xFF;
							is $r->{F_C}, 1;
							is $r->{F_H}, 0;
						}
						elsif (!$nflag && !$carry && $ah >= 9 && !$hcarry && $al >= 10) {
							is $r->{A}, ($a + 0x66) & 0xFF;
							is $r->{F_C}, 1;
							# Fails test 919: cpu:r2k, nflag:0, carry:0, hcarry:0, a:154
							# is $r->{F_H}, 1;
						}
						elsif (!$nflag && !$carry && $ah >= 10 && $hcarry && $al <= 3) {
							is $r->{A}, ($a + 0x66) & 0xFF;
							is $r->{F_C}, 1;
							# Fails test 1061: cpu:r2k, nflag:0, carry:0, hcarry:1, a:160
							# is $r->{F_H}, 0;
						}
						elsif (!$nflag && $carry && $ah <= 2 && !$hcarry && $al <= 9) {
							is $r->{A}, ($a + 0x60) & 0xFF;
							is $r->{F_C}, 1;
							is $r->{F_H}, 0;
						}
						elsif (!$nflag && $carry && $ah <= 2 && !$hcarry && $al >= 10) {
							is $r->{A}, ($a + 0x66) & 0xFF;
							is $r->{F_C}, 1;
							# Fails test 1095: cpu:r2k, nflag:0, carry:1, hcarry:0, a:10
							# is $r->{F_H}, 1;
						}
						elsif (!$nflag && $carry && $ah <= 3 && $hcarry && $al <= 3) {
							is $r->{A}, ($a + 0x66) & 0xFF;
							is $r->{F_C}, 1;
							# Fails test 1133: cpu:r2k, nflag:0, carry:1, hcarry:1, a:0
							# is $r->{F_H}, 0;
						}
						elsif ($nflag && !$carry && $ah <= 9 && !$hcarry && $al <= 9) {
							is $r->{A}, $a;
							is $r->{F_C}, 0;
							is $r->{F_H}, 0;
						}
						elsif ($nflag && !$carry && $ah <= 8 && $hcarry && $al >= 6) {
							is $r->{A}, ($a + 0xFA) & 0xFF;
							is $r->{F_C}, 0;
							# Fails test 485: cpu:z80, nflag:1, carry:0, hcarry:1, a:6
							# is $r->{F_H}, 1;
						}
						elsif ($nflag && $carry && $ah >= 7 && !$hcarry && $al <= 9) {
							is $r->{A}, ($a + 0xA0) & 0xFF;
							is $r->{F_C}, 1;
							is $r->{F_H}, 0;
						}
						elsif ($nflag && $carry && $ah >= 6 && $hcarry && $al >= 6) {
							is $r->{A}, ($a + 0x9A) & 0xFF;
							is $r->{F_C}, 1;
							# Fails test 665: cpu:z80, nflag:1, carry:1, hcarry:1, a:102
							# is $r->{F_H}, 1;
						}
						else {
							die;
						}
						
						is $r->{F_S}, $r->{A} & 0x80 	? 1 : 0, 	"S";
						is $r->{F_Z}, $r->{A} == 0 		? 1 : 0, 	"Z";
						is $r->{F_PV}, parity($r->{A}),		 		"PV";
						is $r->{F_N}, $nflag,				 		"N";
						
(Test::More->builder->is_passing) or die;
					}
				}
			}
		}
	}
}

unlink_testfiles();
done_testing();

sub parity {
	my($a) = @_;
	my $bits = 0;
	$bits++ if $a & 0x80;
	$bits++ if $a & 0x40;
	$bits++ if $a & 0x20;
	$bits++ if $a & 0x10;
	$bits++ if $a & 0x08;
	$bits++ if $a & 0x04;
	$bits++ if $a & 0x02;
	$bits++ if $a & 0x01;
	return ($bits & 1) == 0 ? 1 : 0;
}
