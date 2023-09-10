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
		skip "$cpu not supported by ticks" if $cpu =~ /^ez80$|^r4k$|^r5k$/;
		
		for my $base (0x1000) {
			for my $add (-2, 0, 2) {
				$test_nr++;
				note "Test $test_nr: cpu:$cpu base:$base add:$add";
				
				my $r = ticks(<<END, "-m$cpu");
							ld		sp, $base
							add 	sp, $add
							
							ld		hl, 0
							add 	hl, sp
							rst 	0
END
				my $sum = $base + $add;
				
				is $r->{F_C}, $sum > 65535 ? 1 : 0, "carry";
				is $r->{HL}, $sum & 65535,			"result";
						
				(Test::More->builder->is_passing) or die;
			}
		}
	}
}

unlink_testfiles();
done_testing();
