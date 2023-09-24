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

		for my $dd (qw( HL IX IY )) {
			next if $cpu =~ /^z80_strict|^z180|^80|^gbz80/;
			for my $v (0, 1, -1) {
				my $r = ticks(<<END, "-m$cpu");
						ld $dd, $v
						bool $dd
						rst 0
END
				is $r->{$dd}, $v==0 ? 0 : 1, "$dd result";
				
				(Test::More->builder->is_passing) or die;
			}
		}
	}
}

unlink_testfiles();
done_testing();

