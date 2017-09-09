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

# CPI / CPD
for my $cpu (@CPUS) {
	for my $carry (0, 1) {
		for my $data (1, 2, 3) {
			my $a = 2;
			for my $bc (2, 1) {
				for my $op (qw(cpi cpd)) {
					note "cpu: $cpu, data: $data, a: $a, bc: $bc, op: $op";
					my $carry_set = $carry ? "scf" : "and a";
					my $r = ticks(<<END, "--cpu=$cpu -b -m -l");
						extern __tail
						defc data = 0x100
								$carry_set
								ld hl, data
								ld (hl), $data
								ld a, $a
								ld bc, $bc
								
								$op
								
								jp __tail
END
					# system "z88dk-dis -m$cpu -x test.map test.bin";
					# use Data::Dump 'dump'; say dump($r);
					
					is $r->{F_S}, ($a <  $data 		? 1 : 0), "S";
					is $r->{F_Z}, ($a == $data 		? 1 : 0), "Z";
					is $r->{F_H}, ($a <  $data 		? 1 : 0), "Hf";
					is $r->{F_PV}, ($r->{BC} == 0 	? 0 : 1), "PV";
					is $r->{F_N}, 1,						  "N";
					is $r->{F_C}, $carry,					  "C";					
					is $r->{HL}, $op eq 'cpi' ? 0x101 : 0x0FF,"HL";
					is $r->{BC}, $bc - 1,					  "BC";
				}
			}
		}

	}
}

unlink_testfiles();
done_testing();

