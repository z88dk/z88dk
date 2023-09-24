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

for my $s (qw( BC DE HL IX IY )) {
	for my $d (qw( BC DE HL IX IY )) {
		if ($s ne $d) {
			for my $v (32767, 65535) {
				my $cond_s = ($s =~ /IX|IY/i) ? 
							"!__CPU_INTEL__ && !__CPU_GBZ80__" : "1";
				my $cond_d = ($d =~ /IX|IY/i) ? 
							"!__CPU_INTEL__ && !__CPU_GBZ80__" : "1";
				$ticks->add(<<END, 
					IF $cond_d
							ld $d, 0
					ENDIF
					IF $cond_s
							ld $s, $v
					ENDIF
					IF $cond_s && $cond_d
							ld $d, $s
					ELIF $cond_d
							ld $d, $v
					ENDIF
END
				$s	=>	sub { my($t) = @_;
							  return (($t->{cpu} =~ /^80|^gbz80/ && $s !~ /IX|IY/i) 
								   || ($t->{cpu} !~ /^80|^gbz80/ )) ? $v : 0; },
				$d	=>	sub { my($t) = @_;                                           
							  return (($t->{cpu} =~ /^80|^gbz80/ && $d !~ /IX|IY/i) 
								   || ($t->{cpu} !~ /^80|^gbz80/ )) ? $v : 0; });
			}
		}
	}
}

$ticks->run;

unlink_testfiles();
done_testing();
