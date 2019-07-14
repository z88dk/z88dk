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

# CPUs not supported by ticks: z80n z180 r3k
my @CPUS = (qw( z80 r2k ));
my $test_nr;

# test l_hex_nibble from the z88dk library (uses DAA)
for my $cpu (@CPUS) {
	for my $a (0..15) {
		$test_nr++;
		note "Test $test_nr: cpu:$cpu, a:$a";
		my $r = ticks(<<END, "-m$cpu");
				ld a, $a
				call l_hex_nibble
				rst 0
				
			l_hex_nibble:
				or 0xF0
				daa
				add a,0xA0
				adc a,0x40
				ret
END
		my $exp_out = ord(sprintf("%X", $a));
		is $r->{A}, $exp_out, "$a -> ".chr($exp_out);
	}
}

unlink_testfiles();
done_testing();
