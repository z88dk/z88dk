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

test_cond($ticks, "nz",  sub {my($a,$b)=@_; return ($a&0xff)!=($b&0xff) ? 1 : 0;});
test_cond($ticks, "z",   sub {my($a,$b)=@_; return ($a&0xff)==($b&0xff) ? 1 : 0;});
test_cond($ticks, "nc",  sub {my($a,$b)=@_; return ($a&0xff)>=($b&0xff) ? 1 : 0;});
test_cond($ticks, "c",   sub {my($a,$b)=@_; return ($a&0xff)< ($b&0xff) ? 1 : 0;});
test_cond($ticks, "ne",  sub {my($a,$b)=@_; return ($a&0xff)!=($b&0xff) ? 1 : 0;});
test_cond($ticks, "eq",  sub {my($a,$b)=@_; return ($a&0xff)==($b&0xff) ? 1 : 0;});
test_cond($ticks, "geu", sub {my($a,$b)=@_; return ($a&0xff)>=($b&0xff) ? 1 : 0;});
test_cond($ticks, "ltu", sub {my($a,$b)=@_; return ($a&0xff)< ($b&0xff) ? 1 : 0;});
test_cond($ticks, "gtu", sub {my($a,$b)=@_; return ($a&0xff)> ($b&0xff) ? 1 : 0;});
test_cond($ticks, "leu", sub {my($a,$b)=@_; return ($a&0xff)<=($b&0xff) ? 1 : 0;});

$ticks->run("", "-opt-speed");

unlink_testfiles();
done_testing();

sub test_cond {
	my($ticks, $flag, $func) = @_;
	local $Test::Builder::Level = $Test::Builder::Level + 1;

	for my $b (0, 128) {
		for my $a ($b-1, $b, $b+1) {

			# test jump
			for my $jump ("jr $flag,", "jp $flag,", "j$flag", "j_$flag") {
				$ticks->add(<<END, L=>$func->($a, $b));
							ld l, -1
							
							ld a, $a
							cp $b
							$jump r1
							
				r0:			ld l, 0
							jr r2
							
				r1:			ld l, 1
				r2:
END
			}
			
			# test call
			for my $call ("call $flag,", "c$flag", "c_$flag") {
				$ticks->add(<<END, L=>$func->($a, $b));
							ld l, 0
							
							ld a, $a
							cp $b

							$call r1
							jr r2
							
				r1:			ld l, 1
							ret
				r2:
END
			}
			
			# test ret
			for my $ret ("ret $flag", "r$flag", "r_$flag") {
				$ticks->add(<<END, L=>$func->($a, $b));
							ld l, 0
							
							ld a, $a
							cp $b

							call r1
							jr r2
							
				r1:			ld l, 1
							$ret
							ld l, 0
							ret
				r2:
END
			}		
		}
	}
}
