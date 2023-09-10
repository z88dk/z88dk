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

		$test_nr++;
		note "Test $test_nr: cpu:$cpu";

		my $r = ticks(<<END, "-m$cpu");
					ld 	a, 0
					ld 	b, 42
			loop:	inc a
					djnz loop
					rst 0
END
		is $r->{A}, 42;
				
		(Test::More->builder->is_passing) or die;
	}
}

unlink_testfiles();
done_testing();
