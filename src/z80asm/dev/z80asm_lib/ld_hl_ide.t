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

for my $op ("lhlx", "lhlde", "ld hl, (de)") {
	for my $addr (0x8000, 0xc000) {
		for my $value (0, 0x5555, 0xaaaa, 0xffff) {
			$ticks->add(<<END, HL=>$value);
					ld 		a, $value & 0xff
					ld 		($addr), a
					ld 		a, $value >> 8
					ld 		($addr+1), a
					
					ld 		hl, 0
					ld 		de, $addr
					
					$op
END
		}
	}
}

$ticks->run;

unlink_testfiles();
done_testing();
