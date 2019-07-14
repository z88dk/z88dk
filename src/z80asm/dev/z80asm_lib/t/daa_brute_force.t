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
						my $r = ticks(<<END, "-m$cpu");
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
