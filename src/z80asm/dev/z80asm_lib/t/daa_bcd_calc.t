#------------------------------------------------------------------------------
# Z88DK Z80 Macro Assembler
#
# Test z80asm-*.lib
#
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------
use strict;
use warnings;
use v5.10;
use Test::More;
require '../../t/testlib.pl';

# CPUs not supported by ticks: z80n z180 r3k
my @CPUS = (qw( z80 r2k ));
my $test_nr;

for my $cpu (@CPUS) {
	# Example 3 of z80_cpu_um80.pdf pp 41
	$test_nr++;
	note "Test $test_nr: cpu:$cpu";

	my $r = ticks(<<END, "-m$cpu");
				jr start
		data:	defb 0x01, 0x23, 0x45, 0x67, 0x89
		start:	ld hl, start-1
				ld b, start-data
				xor a
		rotate:	rld
				dec hl
				djnz rotate
				rst 0
END
	is $r->{mem}[2], 0x12;
	is $r->{mem}[3], 0x34;
	is $r->{mem}[4], 0x56;
	is $r->{mem}[5], 0x78;
	is $r->{mem}[6], 0x90;
	
	# Example 4 of z80_cpu_um80.pdf pp 43
	$test_nr++;
	note "Test $test_nr: cpu:$cpu";

	$r = ticks(<<END, "-m$cpu");
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
				rst 0
END
	is $r->{mem}[ 7], 0x00;
	is $r->{mem}[ 8], 0x24;
	is $r->{mem}[ 9], 0x69;
	is $r->{mem}[10], 0x13;
	is $r->{mem}[11], 0x57;
}

unlink_testfiles();
done_testing();
