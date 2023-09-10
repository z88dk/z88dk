#------------------------------------------------------------------------------
# Z88DK Z80 Macro Assembler
#
# Test z88dk-z80asm-*.lib
#
# Copyright (C) Paulo Custodio, 2011-2023
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------

BEGIN { use lib '../../t'; require 'testlib.pl'; }

use Modern::Perl;

my $test_nr;

# test l_hex_nibble from the z88dk library (uses DAA)
for my $cpu (@CPUS) {
	SKIP: {
		skip "$cpu not supported by ticks" if $cpu =~ /^ez80$|^r4k$|^r5k$/;
		skip "$cpu flags not correct in ticks?" if $cpu =~ /^8080$|^8085$/;

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
			
			(Test::More->builder->is_passing) or die;
		}
	}
}

unlink_testfiles();
done_testing();
