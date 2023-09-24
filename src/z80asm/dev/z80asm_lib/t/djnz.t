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

$ticks->add(<<END, HL=>42);
			ld 	hl, 0
			ld 	b, 42
	loop:	inc hl
			djnz loop
END

$ticks->add(<<END, HL=>1);
			ld 	hl, 0
			ld 	b, 1
	loop:	inc hl
			djnz loop
END

$ticks->add(<<END, HL=>256);
			ld 	hl, 0
			ld 	b, 0
	loop:	inc hl
			djnz loop
END

$ticks->run;

unlink_testfiles();
done_testing();
