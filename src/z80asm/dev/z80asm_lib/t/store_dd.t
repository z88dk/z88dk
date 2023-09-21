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
		
		for my $dd (qw( bc de hl sp )) {
			my $var = 0x100;
			my $t = ticks(<<END, "-m$cpu");
					; $cpu $dd
					ld $dd, 0x1234
					ld ($var), $dd
					jp 0
END
			is $t->{mem}[$var+0], 0x34;
			is $t->{mem}[$var+1], 0x12;
			 
			(Test::More->builder->is_passing) or die;
		}
	}
}

unlink_testfiles();
done_testing();
