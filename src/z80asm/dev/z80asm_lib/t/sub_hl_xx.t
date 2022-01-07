#------------------------------------------------------------------------------
# z80asm assembler
# Test z88dk-z80asm-*.lib
# Copyright (C) Paulo Custodio, 2011-2022
# License: http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------

use Modern::Perl;
use Test::More;
use Path::Tiny;
require '../../t/testlib.pl';

my @CPUS = (qw( 8080 gbz80 z80 r2ka ));

my $test_nr;

for my $cpu (@CPUS) {
	for my $reg (qw( bc de hl sp )) {
		for my $carry (0, 1) {
			for my $base (0, 32768, 32769) {
				for my $sub (255, 256, 32767) {
					$test_nr++;
					note "Test $test_nr: cpu:$cpu reg:$reg carry:$carry base:$base sub:$sub";

					my $init_carry = $carry ? "scf" : "and a";
					my $base1 = ($reg eq 'hl') ? $sub : $base;
					
					my $r = ticks(<<END, "-m$cpu");
							ld		hl, $base1
							ld		$reg, $sub
							$init_carry 
							sub 	hl, $reg
							jr	 	0		; need to keep SP
END
					my $sum = $base1 - $sub;
					
					is $r->{F_C}, $sum < 0 ? 1 : 0, 			  "carry";
					is $r->{HL},  $sum < 0 ? $sum + 65536 : $sum, "result";
							
					(Test::More->builder->is_passing) or die;
				}
			}
		}
	}
}

unlink_testfiles();
done_testing();
