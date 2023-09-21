#------------------------------------------------------------------------------
# z80asm assembler
# Test z88dk-z80asm-*.lib
# Copyright (C) Paulo Custodio, 2011-2023
# License: http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------

BEGIN { use lib '../../t'; require 'testlib.pl'; }

use Modern::Perl;

my $test_nr;

for my $cpu (@CPUS) {
	SKIP: {
		skip "$cpu not supported by ticks" if $cpu =~ /^ez80$/;
		
		for my $reg (qw( bc de hl sp )) {
			for my $carry (0, 1) {
				for my $base (0, 32768, 32769) {
					for my $add (255, 256, 32767) {
						$test_nr++;
						note "Test $test_nr: cpu:$cpu reg:$reg carry:$carry base:$base add:$add";

						my $init_carry = $carry ? "scf" : "and a";
						my $base1 = ($reg eq 'hl') ? $add : $base;
						
						my $r = ticks(<<END, "-m$cpu");
								ld		hl, $base1
								ld		$reg, $add
								$init_carry 
								adc 	hl, $reg
								jr	 	0		; need to keep SP
END
						my $sum = $base1 + $add + $carry;
						
						is $r->{F_C}, $sum > 65535 ? 1 : 0, "carry";
						is $r->{HL}, $sum & 65535,			"result";
								
						(Test::More->builder->is_passing) or die;
					}
				}
			}
		}
	}
}

unlink_testfiles();
done_testing();
