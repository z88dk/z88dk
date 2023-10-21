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

for my $s (qw( BC DE HL BC_ DE_ HL_ IX IY )) {
	for my $d (qw( BC DE HL BC_ DE_ HL_ IX IY )) {
		if ($s ne $d) {
			for my $v (32767, 65535) {
				my $cond_s = ($s =~ /IX|IY/i) ? 
							"!__CPU_INTEL__ && !__CPU_GBZ80__" : 
							($s =~ /_/) ? 
							"__CPU_RABBIT__" : "1";
				my $s_ = $s =~ s/_/'/r;
				my $cond_d = ($d =~ /IX|IY/i) ? 
							"!__CPU_INTEL__ && !__CPU_GBZ80__" : 
							($d =~ /_/) ? 
							"__CPU_RABBIT__" : "1";
				my $d_ = $d =~ s/_/'/r;
				$ticks->add(<<END, 
					IF $cond_d
							ld $d_, 0
					ENDIF
					IF $cond_s
							ld $s_, $v
					ENDIF
					IF $cond_s && $cond_d
							ld $d_, $s_
					ELIF $cond_d
							ld $d_, $v
					ENDIF
END
				$s	=>	sub { my($t) = @_;
							  return $v if $t->{cpu} =~ /^80|^gbz80/ && substr($s,0,2) eq substr($d,0,2);
							  return 0 if ($s =~ /IX|IY/i && $t->{cpu} =~ /^80|^gbz80/);
							  return 0 if ($s =~ /_/ && $t->{cpu} !~ /^r.k/);
							  return $v; },
				$d	=>	sub { my($t) = @_;
							  return $v if $t->{cpu} =~ /^80|^gbz80/ && substr($s,0,2) eq substr($d,0,2);
							  return 0 if ($d =~ /IX|IY/i && $t->{cpu} =~ /^80|^gbz80/);
							  return 0 if ($d =~ /_/ && $t->{cpu} !~ /^r.k/);
							  return $v; });
			}
		}
	}
}

$ticks->run;

unlink_testfiles();
done_testing();
