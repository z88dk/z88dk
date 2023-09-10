#------------------------------------------------------------------------------
# z80asm assembler
# Test z88dk-z80asm-*.lib
# Copyright (C) Paulo Custodio, 2011-2023
# License: http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------

BEGIN { use lib '../../t'; require 'testlib.pl'; }

use Modern::Perl;

my $test_nr;

for my $cpu (@CPUS) {
	SKIP: {
		skip "$cpu not supported by ticks" if $cpu =~ /^ez80$|^r4k$|^r5k$/;
		
		$test_nr++;
		note "Test $test_nr: cpu:$cpu";

		for my $op ("ldi", "ldir") {
			my $r = ticks(<<END, "-m$cpu");
						jp start
				src:	defb 1,2,3,4
				dst:	defb 0,0,0,0
				start:	ld hl, src
						ld de, dst
						ld bc, 4
						$op
						rst 0
END
			my $src = 3; my $dst = $src+4;
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

			(Test::More->builder->is_passing) or die; 
		}
			
		for my $op ("ldd", "lddr") {
			my $r = ticks(<<END, "-m$cpu");
						jp start
				src:	defb 1,2,3,4
				dst:	defb 0,0,0,0
				start:	ld hl, src+3
						ld de, dst+3
						ld bc, 4
						$op
						rst 0
END
			my $src = 3; my $dst = $src+4;
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
			
			(Test::More->builder->is_passing) or die; 
		}
	}	
}

unlink_testfiles();
done_testing();
