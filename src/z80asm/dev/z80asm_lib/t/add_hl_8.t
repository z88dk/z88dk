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

my @CPUS = (qw( z80 z80n ));

my $test_nr;

for my $cpu (@CPUS) {
	for my $reg (qw( bc de hl )) {
		for my $base (0, 255, 65534) {
			for my $add (1, 2) {
				$test_nr++;
				note "Test $test_nr: cpu:$cpu reg:$reg base:$base add:$add";
				
				my $r = ticks(<<END, "-m$cpu");
						ld		$reg, $base
						ld		a, $add
						
						add 	$reg, a
						
						push 	$reg
						pop		hl
						rst 	0
END
				my $sum = $base + $add;
				
				# z80n does not update carry, neither does emulation
				#is $r->{F_C}, $sum > 65535 ? 1 : 0, "carry";
				is $r->{HL}, $sum & 65535,			"result";
						
				(Test::More->builder->is_passing) or die;
			}
		}
	}
}

unlink_testfiles();
done_testing();
