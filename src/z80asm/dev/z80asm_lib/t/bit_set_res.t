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

my @CPUS = (qw( 8080 z80 ));

my $test_nr;

for my $cpu (@CPUS) {
	for my $reg (qw( b c d e h l (hl) a )) {
		for my $bit (0..7) {
			for my $n (0, 0xFF) {
				# BIT
				$test_nr++;
				note "Test $test_nr: cpu:$cpu reg:$reg bit:$bit n:$n";

				my $r = ticks(<<END, "-m$cpu");
							ld 		hl, 0x1000
							ld 		$reg, $n
							bit.a 	$bit, $reg
							rst 	0
END
				is $r->{F_Z}, $n==0 ? 1 : 0,	"result";
						
				(Test::More->builder->is_passing) or die; 

				# RES
				$test_nr++;
				note "Test $test_nr: cpu:$cpu reg:$reg bit:$bit n:$n";

				$r = ticks(<<END, "-m$cpu");
							ld 		hl, 0x1000
							ld 		$reg, $n
							res.a 	$bit, $reg
							
							ld		a, $reg
							rst 	0
END
				is $r->{A}, $n & (~(1 << $bit)),	"result";
						
				(Test::More->builder->is_passing) or die; 

				# SET
				$test_nr++;
				note "Test $test_nr: cpu:$cpu reg:$reg bit:$bit n:$n";

				$r = ticks(<<END, "-m$cpu");
							ld 		hl, 0x1000
							ld 		$reg, $n
							set.a 	$bit, $reg
							
							ld		a, $reg
							rst 	0
END
				is $r->{A}, $n | (1 << $bit),	"result";
						
				(Test::More->builder->is_passing) or die; 
			}
		}
	}
}

unlink_testfiles();
done_testing();
