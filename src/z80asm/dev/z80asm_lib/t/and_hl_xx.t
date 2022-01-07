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

my @CPUS = (qw( 8080 z80 r2ka ));

my $test_nr;

for my $cpu (@CPUS) {
	for my $reg (qw( de bc )) {
		for my $a (0, 0xAAAA) {
			for my $b (0x5555, 0xFFFF) {
				$test_nr++;
				note "Test $test_nr: cpu:$cpu reg:$reg a:$a b:$b";

				my $r = ticks(<<END, "-m$cpu");
							ld		hl, $a
							ld		$reg, $b
							and.a	hl, $reg
							rst 	0
END
				my $x = $a & $b;
				is $r->{HL}, $x,			"result";
						
				(Test::More->builder->is_passing) or die; 
			}
		}
	}
}

unlink_testfiles();
done_testing();
