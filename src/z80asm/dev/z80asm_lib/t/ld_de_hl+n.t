#!/usr/bin/env perl

#------------------------------------------------------------------------------
# z80asm assembler
# Test z88dk-z80asm-*.lib
# Copyright (C) Paulo Custodio, 2011-2026
# License: http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------

BEGIN { use lib '../../t'; require 'testlib.pl'; }

use Modern::Perl;

my $ticks = Ticks->new;

for my $base (0, 255, 32767, 0xffff) {
	for my $add (0, 1, 0x7f, 0x80, 0xff) {
		for my $op ("ldhi $add", "adi hl, $add", "ld de, hl+$add") {
			my $res = $base + $add;
			
			$ticks->add(<<END, HL=>$base, DE=>$res);
					ld		hl, $base
					$op
END
		}
	}
}

$ticks->run;

unlink_testfiles();
done_testing();
