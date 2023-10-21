#------------------------------------------------------------------------------
# z80asm assembler
# Test z88dk-z80asm-*.lib
# Copyright (C) Paulo Custodio, 2011-2023
# License: http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------

BEGIN { use lib '../../t'; require 'testlib.pl'; }

use Modern::Perl;

for my $cpu (@CPUS) {
	SKIP: {
		skip "$cpu not supported by ticks" if $cpu =~ /^ez80$/;

		for my $dd (qw( B  C  D  E  H  L  BC  DE  HL  IX IY 
						B_ C_ D_ E_ H_ L_ BC_ DE_ HL_       )) {
			next if $dd =~ /ix|iy/i && $cpu =~ /^80|gbz80/;
			next if $dd =~ /_/ && $cpu !~ /^r4k|^r5k/;
			
			my $reg = $dd =~ s/_/'/r;
			my $r = ticks(<<END, "-m$cpu");
				IF __CPU_R4K__ || __CPU_R5K__
					;; Enable R4K instruction mode on the R4K
					ld      a,0xC0
					ioi ld  (0x0420),a      ;EDMR register (p299 in R4000UM.pdf)
				ENDIF			
					ld $reg, -1
					clr $reg
					rst 0
END
				is $r->{$dd}, 0, "$dd result";
				
				(Test::More->builder->is_passing) or die;
		}
	}
}

unlink_testfiles();
done_testing();

