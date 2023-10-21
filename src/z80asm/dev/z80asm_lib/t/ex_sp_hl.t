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

$ticks->add(<<END, HL=>0x1234, DE=>0x5678);
			jp start
	data:	defw 0, 0
	start:	ld hl, 0x1234
			push hl
			ld hl, 0x5678

			ex (sp), hl
			pop de
END

$ticks->run;

unlink_testfiles();
done_testing();
