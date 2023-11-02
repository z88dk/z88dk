#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2309
# z80asm: Request for emulated instructions

for my $cpu (qw( ez80 ez80_z80 r2ka r3k z180 z80 z80n )) {
	for my $idx (qw( ix iy )) {
		for my $dd (qw( bc de hl ix iy )) {
			note "$cpu $idx $dd";
			
			spew("$test.asm", <<END);
	ld $dd, ($idx+8)
	ld ($idx+8), $dd
END
			capture_ok("z88dk-z80asm -m$cpu -b -l $test.asm", "");
			run_ok("z88dk-dis -m$cpu $test.bin > $test.dis");
			my $dis = slurp("$test.dis");
			for ($dis) {
				s/^\s+//gm;
				s/\s+;.*\s*/:/gm;
				s/[ \t]+/ /gm;
				s/:$//s;
			}
			
			if ($cpu =~ /ez80/) {
				is $dis, "ld $dd,($idx+\$08):ld ($idx+\$08),$dd";
			}
			else {
				my($ddh, $ddl) = split //, $dd;
				if ($cpu =~ /^r/ && $dd eq 'hl') {
					is $dis, "ld $dd,($idx+\$08):ld ($idx+\$08),$dd";
				}
				elsif ($dd =~ /ix|iy/) {
					is $dis, "push $dd:".
							 "ex (sp),hl:".
							 "ld l,($idx+\$08):ld h,($idx+\$09):".
							 "ex (sp),hl:".
							 "pop $dd:".
							 
							 "push $dd:".
							 "ex (sp),hl:".
							 "ld ($idx+\$08),l:ld ($idx+\$09),h:".
							 "ex (sp),hl:".
							 "pop $dd";
				}
				else {
					is $dis, "ld $ddl,($idx+\$08):ld $ddh,($idx+\$09):".
							 "ld ($idx+\$08),$ddl:ld ($idx+\$09),$ddh";
				}
			}
			
			die unless Test::More->builder->is_passing;
		}
	}
}

unlink_testfiles;
done_testing;
