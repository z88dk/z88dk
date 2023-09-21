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

		for my $opts ("-m$cpu", "-m$cpu -opt-speed") {
			test_cond($opts, "nz",  sub {my($a,$b)=@_; return ($a&0xff)!=($b&0xff) ? 1 : 0;});
			test_cond($opts, "z",   sub {my($a,$b)=@_; return ($a&0xff)==($b&0xff) ? 1 : 0;});
			test_cond($opts, "nc",  sub {my($a,$b)=@_; return ($a&0xff)>=($b&0xff) ? 1 : 0;});
			test_cond($opts, "c",   sub {my($a,$b)=@_; return ($a&0xff)< ($b&0xff) ? 1 : 0;});
			test_cond($opts, "ne",  sub {my($a,$b)=@_; return ($a&0xff)!=($b&0xff) ? 1 : 0;});
			test_cond($opts, "eq",  sub {my($a,$b)=@_; return ($a&0xff)==($b&0xff) ? 1 : 0;});
			test_cond($opts, "geu", sub {my($a,$b)=@_; return ($a&0xff)>=($b&0xff) ? 1 : 0;});
			test_cond($opts, "ltu", sub {my($a,$b)=@_; return ($a&0xff)< ($b&0xff) ? 1 : 0;});
			test_cond($opts, "gtu", sub {my($a,$b)=@_; return ($a&0xff)> ($b&0xff) ? 1 : 0;});
			test_cond($opts, "leu", sub {my($a,$b)=@_; return ($a&0xff)<=($b&0xff) ? 1 : 0;});
		}
	}
}

unlink_testfiles();
done_testing();

sub test_cond {
	my($opts, $flag, $func) = @_;
	local $Test::Builder::Level = $Test::Builder::Level + 1;

	for my $b (0, 128) {
		for my $a ($b-1, $b, $b+1) {

			# test jump
			for my $jump ("jr $flag,", "jp $flag,", "j$flag", "j_$flag") {
				my $r = ticks(<<END, "$opts");
							ld l, -1
							
							ld a, $a
							cp $b
							$jump r1
							
				r0:			ld l, 0
							rst 0
							
				r1:			ld l, 1
							rst 0
END
				is $r->{L}, $func->($a, $b), "jump result";
				
				(Test::More->builder->is_passing) or die;
			}
			
			# test call
			for my $call ("call $flag,", "c$flag", "c_$flag") {
				my $r = ticks(<<END, "$opts");
							ld l, 0
							
							ld a, $a
							cp $b

							$call r1
							rst 0
							
				r1:			ld l, 1
							ret
END
				is $r->{L}, $func->($a, $b), "call result";
				
				(Test::More->builder->is_passing) or die;
			}
			
			# test ret
			for my $ret ("ret $flag", "r$flag", "r_$flag") {
				my $r = ticks(<<END, "$opts");
							ld l, 0
							
							ld a, $a
							cp $b

							call r1
							rst 0
							
				r1:			ld l, 1
							$ret
							ld l, 0
							ret
END
				is $r->{L}, $func->($a, $b), "ret result";
				
				(Test::More->builder->is_passing) or die;
			}		
		}
	}
}
