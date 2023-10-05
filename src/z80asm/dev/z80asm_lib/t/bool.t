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

for my $dd (qw( HL IX IY )) {
	for my $v (0, 1, -1) {
		my $cond = ($dd =~ /IX|IY/i) ? "!__CPU_INTEL__ && !__CPU_GBZ80__" : "1";
		$ticks->add(<<END, 
			IF $cond
				ld $dd, $v
				bool $dd
			ENDIF
END
			$dd => sub { my($t) = @_;
						 return 0 if ($dd =~ /IX|IY/i && $t->{cpu} =~ /^80|^gbz80/);
						 return $v==0 ? 0 : 1; });
	}
}

$ticks->run;

unlink_testfiles();
done_testing();

