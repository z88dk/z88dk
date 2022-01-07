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

	for my $op ("ldi", "ldir") {
		my $r = ticks(<<END, "-m$cpu");
					jr start
			src:	defb 1,2,3,4
			dst:	defb 0,0,0,0
			start:	ld hl, src
					ld de, dst
					ld bc, 4
					$op
					rst 0
END
		my $src = 2; my $dst = $src+4;
		is $r->{mem}[$src+0], 1;
		is $r->{mem}[$src+1], 2;
		is $r->{mem}[$src+2], 3;
		is $r->{mem}[$src+3], 4;
		
		if ($op eq "ldi") {
			is $r->{mem}[$dst+0], 1;
			is $r->{mem}[$dst+1], 0;
			is $r->{mem}[$dst+2], 0;
			is $r->{mem}[$dst+3], 0;
			is $r->{HL}, $src+1;
			is $r->{DE}, $dst+1;
			is $r->{BC}, 3;
		}
		else {
			is $r->{mem}[$dst+0], 1;
			is $r->{mem}[$dst+1], 2;
			is $r->{mem}[$dst+2], 3;
			is $r->{mem}[$dst+3], 4;
			is $r->{HL}, $src+4;
			is $r->{DE}, $dst+4;
			is $r->{BC}, 0;
		}
	}
			
	for my $op ("ldd", "lddr") {
		my $r = ticks(<<END, "-m$cpu");
					jr start
			src:	defb 1,2,3,4
			dst:	defb 0,0,0,0
			start:	ld hl, src+3
					ld de, dst+3
					ld bc, 4
					$op
					rst 0
END
		my $src = 2; my $dst = $src+4;
		is $r->{mem}[$src+0], 1;
		is $r->{mem}[$src+1], 2;
		is $r->{mem}[$src+2], 3;
		is $r->{mem}[$src+3], 4;
		
		if ($op eq "ldd") {
			is $r->{mem}[$dst+0], 0;
			is $r->{mem}[$dst+1], 0;
			is $r->{mem}[$dst+2], 0;
			is $r->{mem}[$dst+3], 4;
			is $r->{HL}, $src+2;
			is $r->{DE}, $dst+2;
			is $r->{BC}, 3;
		}
		else {
			is $r->{mem}[$dst+0], 1;
			is $r->{mem}[$dst+1], 2;
			is $r->{mem}[$dst+2], 3;
			is $r->{mem}[$dst+3], 4;
			is $r->{HL}, $src-1;
			is $r->{DE}, $dst-1;
			is $r->{BC}, 0;
		}
	}	
}

unlink_testfiles();
done_testing();
