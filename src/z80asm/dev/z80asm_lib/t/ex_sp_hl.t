#------------------------------------------------------------------------------
# z80asm assembler
# Test z88dk-z80asm-*.lib
# Copyright (C) Paulo Custodio, 2011-2022
# License: http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------

use Modern::Perl;
use Test::More;
require '../../t/testlib.pl';

my @CPUS = (qw( z80 gbz80 ));

my $test_nr;

for my $cpu (@CPUS) {

	$test_nr++;
	note "Test $test_nr: cpu:$cpu";

	my $r = ticks(<<END, "-m$cpu");
				jr start
		data:	defw 0, 0
		start:	ld hl, 0x1234
				push hl
				ld hl, 0x5678
				ex (sp), hl
				
				ld a, l				; gbz80 does not have ld (NN),hl
				ld (data), a
				ld a,h
				ld (data+1), a
				
				pop hl
				ld a, l
				ld (data+2), a
				ld a,h
				ld (data+3), a
				rst 0
END
	is $r->{mem}[2], 0x34;
	is $r->{mem}[3], 0x12;
	is $r->{mem}[4], 0x78;
	is $r->{mem}[5], 0x56;
	
}

unlink_testfiles();
done_testing();
