#!/usr/bin/env perl

BEGIN { use lib '../../t'; require 'testlib.pl'; }

use Modern::Perl;

# ld (hl), ixy
for my $cpu (@CPUS) {
	SKIP: {
		skip "$cpu not supported by ticks" if $cpu =~ /ez80|r4k|r5k/;
		skip "$cpu does not have index registers" if $cpu =~ /8080|8085|gbz80/;
		
		for my $x (qw( ix iy )) {
			for my $inc (0, 1, 2) {
				my $ldihl = ("ld (hl)", "ld (hl+)", "ldi (hl)")[$inc];
				my $r = ticks(<<END, "-m$cpu");
							jp start
					var:	defw 0
					start:
							ld de, 0x5678
							ld hl, var
							ld $x, 0x1234
							$ldihl, $x
							
							rst 0
END
				is $r->{HL}, $inc ? 5 : 3;
				is $r->{DE}, 0x5678;
				is $r->{mem}[3], 0x34;
				is $r->{mem}[4], 0x12;

				(Test::More->builder->is_passing) or die;
			}
		}
	}
}

# ld ixy, (hl)
for my $cpu (@CPUS) {
	SKIP: {
		skip "$cpu not supported by ticks" if $cpu =~ /ez80|r4k|r5k/;
		skip "$cpu does not have index registers" if $cpu =~ /8080|8085|gbz80/;
		
		for my $x (qw( ix iy )) {
			for my $inc (0, 1, 2) {
				my $ld =  ("ld",   "ld",    "ldi" )[$inc];
				my $ihl = ("(hl)", "(hl+)", "(hl)")[$inc];
				my $r = ticks(<<END, "-m$cpu");
						jp start
				var:	defw 0x1234
				start:
						ld de, 0x5678
						ld hl, var
						ld $x, 0
						$ld $x, $ihl
						
						rst 0
END
				is $r->{HL}, $inc ? 5 : 3;
				is $r->{DE}, 0x5678;
				is $r->{uc($x)}, 0x1234;

				(Test::More->builder->is_passing) or die;
			}
		}
	}
}

unlink_testfiles();
done_testing();
