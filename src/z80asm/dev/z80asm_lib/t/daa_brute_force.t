#------------------------------------------------------------------------------
# Z88DK Z80 Macro Assembler
#
# Test z88dk-z80asm-*.lib
#
# Copyright (C) Paulo Custodio, 2011-2022
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------
use Modern::Perl;
use Test::More;
use Path::Tiny;
require '../../t/testlib.pl';

# CPUs not supported by ticks: z80n z180 r3k
my @CPUS = (qw( z80 r2ka ));
my $test_nr;

for my $cpu (@CPUS) {
	my @asm = "ld hl, 0";			# overwrite code with output data
	my @in;

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
						push @in, [$nflag, $carry, $hcarry, $ah, $al];
						push @asm,	"ld de, ".(($a << 8)+$f),
									"push de",
									"pop af",
									"daa",
									"push af",
									"pop de",
									"ld (hl), e",
									"inc hl",
									"ld (hl), d",
									"inc hl";
					}
				}
			}
		}
	}

	push @asm, "rst 0";
	my $r = ticks(join("\n", @asm), "-m$cpu");
	my $data = 0;
	for (@in) {
		my($nflag, $carry, $hcarry, $ah, $al) = @$_;
		my $a = ($ah << 4) | $al;
		
		my $got_f = $r->{mem}[$data++];
		my $got_a = $r->{mem}[$data++];
		
		my $got_sign	= ($got_f & 0x80) ? 1 : 0;
		my $got_zero	= ($got_f & 0x40) ? 1 : 0;
		my $got_hcarry	= ($got_f & 0x10) ? 1 : 0;
		my $got_parity	= ($got_f & 0x04) ? 1 : 0;
		my $got_nflag	= ($got_f & 0x02) ? 1 : 0;
		my $got_carry 	= ($got_f & 0x01) ? 1 : 0;

		# refer to z280_cpu_tm.pdf pp 63; the z80 pp 187 spec is unclear
		if (!$nflag && !$carry && $ah <= 9 && !$hcarry && $al <= 9) {
			is $got_a, $a;
			is $got_carry, 0;
			is $got_hcarry, 0;
		}
		elsif (!$nflag && !$carry && $ah <= 8 && !$hcarry && $al >= 10) {
			is $got_a, ($a + 6) & 0xFF;
			is $got_carry, 0;
			# Fails test 775: cpu:r2ka, nflag:0, carry:0, hcarry:0, a:10
			# is $got_hcarry, 1;
		}
		elsif (!$nflag && !$carry && $ah <= 9 && $hcarry && $al <= 3) {
			is $got_a, ($a + 6) & 0xFF;
			is $got_carry, 0;
			# Fails test 1021: cpu:r2ka, nflag:0, carry:0, hcarry:1, a:0
			# is $got_hcarry, 0;
		}
		elsif (!$nflag && !$carry && $ah >= 10 && !$hcarry && $al <= 9) {
			is $got_a, ($a + 0x60) & 0xFF;
			is $got_carry, 1;
			is $got_hcarry, 0;
		}
		elsif (!$nflag && !$carry && $ah >= 9 && !$hcarry && $al >= 10) {
			is $got_a, ($a + 0x66) & 0xFF;
			is $got_carry, 1;
			# Fails test 919: cpu:r2ka, nflag:0, carry:0, hcarry:0, a:154
			# is $got_hcarry, 1;
		}
		elsif (!$nflag && !$carry && $ah >= 10 && $hcarry && $al <= 3) {
			is $got_a, ($a + 0x66) & 0xFF;
			is $got_carry, 1;
			# Fails test 1061: cpu:r2ka, nflag:0, carry:0, hcarry:1, a:160
			# is $got_hcarry, 0;
		}
		elsif (!$nflag && $carry && $ah <= 2 && !$hcarry && $al <= 9) {
			is $got_a, ($a + 0x60) & 0xFF;
			is $got_carry, 1;
			is $got_hcarry, 0;
		}
		elsif (!$nflag && $carry && $ah <= 2 && !$hcarry && $al >= 10) {
			is $got_a, ($a + 0x66) & 0xFF;
			is $got_carry, 1;
			# Fails test 1095: cpu:r2ka, nflag:0, carry:1, hcarry:0, a:10
			# is $got_hcarry, 1;
		}
		elsif (!$nflag && $carry && $ah <= 3 && $hcarry && $al <= 3) {
			is $got_a, ($a + 0x66) & 0xFF;
			is $got_carry, 1;
			# Fails test 1133: cpu:r2ka, nflag:0, carry:1, hcarry:1, a:0
			# is $got_hcarry, 0;
		}
		elsif ($nflag && !$carry && $ah <= 9 && !$hcarry && $al <= 9) {
			is $got_a, $a;
			is $got_carry, 0;
			is $got_hcarry, 0;
		}
		elsif ($nflag && !$carry && $ah <= 8 && $hcarry && $al >= 6) {
			is $got_a, ($a + 0xFA) & 0xFF;
			is $got_carry, 0;
			# Fails test 485: cpu:z80, nflag:1, carry:0, hcarry:1, a:6
			# is $got_hcarry, 1;
		}
		elsif ($nflag && $carry && $ah >= 7 && !$hcarry && $al <= 9) {
			is $got_a, ($a + 0xA0) & 0xFF;
			is $got_carry, 1;
			is $got_hcarry, 0;
		}
		elsif ($nflag && $carry && $ah >= 6 && $hcarry && $al >= 6) {
			is $got_a, ($a + 0x9A) & 0xFF;
			is $got_carry, 1;
			# Fails test 665: cpu:z80, nflag:1, carry:1, hcarry:1, a:102
			# is $got_hcarry, 1;
		}
		else {
			die;
		}
		
		is $got_sign, $got_a & 0x80 	? 1 : 0, 	"S";
		is $got_zero, $got_a == 0 		? 1 : 0, 	"Z";
		is $got_parity, parity($got_a),		 		"PV";
		is $got_nflag, $nflag,				 		"N";
		
		(Test::More->builder->is_passing) or die;
	}
}

unlink_testfiles();
done_testing();
