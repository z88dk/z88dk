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

		for my $dd (qw( hl ix iy )) {
			next if $dd =~ /ix|iy/ && $cpu =~ /^80|gbz80/;
			my $r = ticks(<<END, "-m$cpu");
				IF __CPU_R4K__ || __CPU_R5K__
					;; Enable R4K instruction mode on the R4K
					ld      a,0xC0
					ioi ld  (0x0420),a      ;EDMR register (p299 in R4000UM.pdf)
				ENDIF			
					ld a, 0
					ld $dd, r1
					call ($dd)
					rst 0
					
				r1:	inc a
					ret
END
				is $r->{A}, 1, "result";
				
				(Test::More->builder->is_passing) or die;
		}
	}
}

unlink_testfiles();
done_testing();

