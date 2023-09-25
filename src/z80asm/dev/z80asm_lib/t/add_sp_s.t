#!/usr/bin/env perl

#------------------------------------------------------------------------------
# z80asm assembler
# Test z88dk-z80asm-*.lib
# Copyright (C) Paulo Custodio, 2011-2023
# License: http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------

BEGIN { use lib '../../t'; require 'testlib.pl'; }

use Modern::Perl;

my $ticks = Ticks->new;

for my $base (0x1000, 0x4000) {
	for my $add (-127, 0, 127) {
		my $sum = $base + ($add & 0xFFFF);
		
		$ticks->add(<<END, 
					ld		sp, $base
					add 	sp, $add
END
			F_C	=> $sum > 0xFFFF ? 1 : 0,
			SP	=> $sum & 0xFFFF);
	}
}

$ticks->run;

unlink_testfiles();
done_testing();
