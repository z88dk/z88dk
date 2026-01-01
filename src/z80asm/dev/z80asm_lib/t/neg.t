#------------------------------------------------------------------------------
# z80asm assembler
# Test z88dk-z80asm-*.lib
# Copyright (C) Paulo Custodio, 2011-2026
# License: http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------

BEGIN { use lib '../../t'; require 'testlib.pl'; }

use Modern::Perl;

for my $cpu (@CPUS) {
	SKIP: {
		skip "$cpu not supported by ticks" if $cpu =~ /^ez80$/;
		skip "strict $cpu" if $cpu =~ /_strict/;

		for my $value (-1, 0, 1) {
			for my $dd (qw( B  C  D  E  H  L  BC  DE  HL  IX IY )) {
				next if $dd =~ /ix|iy/i && $cpu =~ /^80|gbz80/;
				
				my $r = ticks(<<END, "-m$cpu");
					IF __CPU_R4K__ || __CPU_R5K__ || __CPU_R6K__
						;; Enable R4K instruction mode on the R4K
						ld      a,0xC0
						ioi ld  (0x0420),a      ;EDMR register (p299 in R4000UM.pdf)
					ENDIF			
						ld $dd, $value
						neg $dd
						jp 0
END
					$dd =~ /[A-Z]+/;
					my $mask = length($&)==1 ? 0xff : 0xffff;
					is $r->{$dd}, (-$value) & $mask, "$dd result";
					
					(Test::More->builder->is_passing) or die;
			}
		}
	}
}

unlink_testfiles();
done_testing();
