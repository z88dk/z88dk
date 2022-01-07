#------------------------------------------------------------------------------
# z80asm assembler
# Test z88dk-z80asm-*.lib
# Copyright (C) Paulo Custodio, 2011-2022
# License: http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------

use Modern::Perl;
use Test::More;
require '../../t/testlib.pl';

my @CPUS = (qw( 8080 z80 gbz80 r2ka ));

my $test_nr;

for my $cpu (@CPUS) {

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
}

unlink_testfiles();
done_testing();
