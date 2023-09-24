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

$ticks->add(<<END, HL=>42);
			ld 	hl, 0
			ld 	b, 42
	loop:	inc hl
			djnz b, loop
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

$ticks->add(<<END, HL=>42);
	IF __CPU_RABBIT__
			ld 	hl, 0
			exx
			ld 	b, 42
			exx
			ld b, 1
	loop:	inc hl
			altd djnz loop
	ELSE
			ld hl, 42
	ENDIF
END

$ticks->add(<<END, HL=>42);
	IF __CPU_RABBIT__
			ld 	hl, 0
			exx
			ld 	b, 42
			exx
			ld b, 1
	loop:	inc hl
			djnz b', loop
	ELSE
			ld hl, 42
	ENDIF
END

$ticks->add(<<END, HL=>1042);
	IF __CPU_R4K__ || __CPU_R5K__
			ld 	hl, 0
			exx
			ld 	bc, 1042
			exx
			ld 	bc, 1
	loop:	inc hl
			dwjnz bc', loop
	ELSE
			ld hl, 1042
	ENDIF
END

$ticks->add(<<END, HL=>1042);
	IF __CPU_R4K__ || __CPU_R5K__
			ld 	hl, 0
			exx
			ld 	bc, 1042
			exx
			ld 	bc, 1
	loop:	inc hl
			altd dwjnz bc, loop
	ELSE
			ld hl, 1042
	ENDIF
END

$ticks->add(<<END, HL=>1042);
	IF __CPU_R4K__ || __CPU_R5K__
			ld 	hl, 0
			ld 	bc, 1042
	loop:	inc hl
			dwjnz bc, loop
	ELSE
			ld hl, 1042
	ENDIF
END

$ticks->add(<<END, HL=>1042);
	IF __CPU_R4K__ || __CPU_R5K__
			ld 	hl, 0
			ld 	bc, 1042
	loop:	inc hl
			dwjnz bc, loop
	ELSE
			ld hl, 1042
	ENDIF
END


$ticks->run("", "-opt-speed");

unlink_testfiles();
done_testing();
