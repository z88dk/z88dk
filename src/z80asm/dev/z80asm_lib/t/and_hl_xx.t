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
		
		for my $reg (qw( de )) {
			for my $a (0, 0xAAAA) {
				for my $b (0x5555, 0xFFFF) {
					$test_nr++;
					note "Test $test_nr: cpu:$cpu reg:$reg a:$a b:$b";

					my $r = ticks(<<END, "-m$cpu");
								ld		hl, $a
								ld		$reg, $b
								and		hl, $reg
								rst 	0
END
					my $x = $a & $b;
					is $r->{HL}, $x,			"result";
							
					(Test::More->builder->is_passing) or die; 
				}
			}
		}
	}
}

unlink_testfiles();
done_testing();
