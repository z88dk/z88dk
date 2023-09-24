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

# test l_hex_nibble from the z88dk library (uses DAA)
for my $a (0..15) {
	my $exp_out = ord(sprintf("%X", $a));
	$ticks->add(<<END, A=>$exp_out);
			ld a, $a
			call l_hex_nibble
			jr cont
			
		l_hex_nibble:
			or 0xF0
			daa
			add a,0xA0
			adc a,0x40
			ret
		cont:
END
}

$ticks->run;

unlink_testfiles();
done_testing();
