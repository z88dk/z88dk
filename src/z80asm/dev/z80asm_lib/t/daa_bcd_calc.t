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

# Example 3 of z80_cpu_um80.pdf pp 41
$ticks->add(<<END, 
			jr start
	data:	defb 0x01, 0x23, 0x45, 0x67, 0x89
	start:	ld hl, start-1
			ld b, start-data
			xor a
	rotate:	rld
			dec hl
			djnz rotate
END
			B  => sub { my($t) = @_;
						local $Test::Builder::Level = $Test::Builder::Level + 1;
						is $t->{mem}[$t->{labels}{L1_data}+0], 0x12, "BCD digit 0";
						is $t->{mem}[$t->{labels}{L1_data}+1], 0x34, "BCD digit 1";
						is $t->{mem}[$t->{labels}{L1_data}+2], 0x56, "BCD digit 2";
						is $t->{mem}[$t->{labels}{L1_data}+3], 0x78, "BCD digit 3";
						is $t->{mem}[$t->{labels}{L1_data}+4], 0x90, "BCD digit 4";
						return 0;
			});

# Example 4 of z80_cpu_um80.pdf pp 43
$ticks->add(<<END, 
			jr start
	arg1:	defb 0x01, 0x23, 0x45, 0x67, 0x89
	arg1e:
	arg2:	defb 0x00, 0x98, 0x76, 0x54, 0x32
	arg2e:
	start:	ld de, arg1e-1
			ld hl, arg2e-1
			ld b, arg1e-arg1
			and a
	subdec:	ld a,(de)
			sbc a,(hl)
			daa
			ld (hl),a
			dec hl
			dec de
			djnz subdec
END
			B  => sub { my($t) = @_;
						local $Test::Builder::Level = $Test::Builder::Level + 1;
						is $t->{mem}[$t->{labels}{L2_arg2}+0], 0x00, "BCD digit 0";
						is $t->{mem}[$t->{labels}{L2_arg2}+1], 0x24, "BCD digit 1";
						is $t->{mem}[$t->{labels}{L2_arg2}+2], 0x69, "BCD digit 2";
						is $t->{mem}[$t->{labels}{L2_arg2}+3], 0x13, "BCD digit 3";
						is $t->{mem}[$t->{labels}{L2_arg2}+4], 0x57, "BCD digit 4";
						return 0;
			});

$ticks->run;

unlink_testfiles();
done_testing();
