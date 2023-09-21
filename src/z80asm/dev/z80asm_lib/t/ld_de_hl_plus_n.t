#------------------------------------------------------------------------------
# z80asm assembler
# Test z88dk-z80asm-*.lib
# Copyright (C) Paulo Custodio, 2011-2023
# License: http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------

BEGIN { use lib '../../t'; require 'testlib.pl'; }

use Modern::Perl;

for my $cpu (@CPUS) {
	SKIP: {
		skip "$cpu not supported by ticks" if $cpu =~ /^ez80$/;
		
		for my $hl (32767, 65535) {
			for my $u (127, 255) {
				my $t = ticks(<<END, "-m$cpu");
					; $cpu $hl $u
					ld hl, $hl
					ld de, -1
					ld de, hl+$u
					rst 0
END
				is $t->{DE}, ($hl + $u) & 0xFFFF, "result";
				is $t->{HL}, $hl, "result";
				
				(Test::More->builder->is_passing) or die;
			}
		}
	}
}

unlink_testfiles();
done_testing();

