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

for my $hl (32767, 65535) {
	for my $u (127, 255) {
		$ticks->add(<<END, HL=>$hl, DE=>$hl + $u);
			ld hl, $hl
			ld de, -1
			ld de, hl+$u
END
	}
}

$ticks->run;

unlink_testfiles();
done_testing();

