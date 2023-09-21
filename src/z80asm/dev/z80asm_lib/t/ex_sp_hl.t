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
		skip "$cpu not supported by ticks" if $cpu =~ /^ez80$/;

		$test_nr++;
		note "Test $test_nr: cpu:$cpu";

		my $r = ticks(<<END, "-m$cpu");
					jp start
			data:	defw 0, 0
			start:	ld hl, 0x1234
					push hl
					ld hl, 0x5678
					ex (sp), hl
					
					ld (data), hl
					
					pop hl
					ld (data+2), hl

					rst 0
END
		is $r->{mem}[3], 0x34;
		is $r->{mem}[4], 0x12;
		is $r->{mem}[5], 0x78;
		is $r->{mem}[6], 0x56;
	
		(Test::More->builder->is_passing) or die;
	}
}

unlink_testfiles();
done_testing();
