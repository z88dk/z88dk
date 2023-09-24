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

my $test_nr = 0;

# ld (hl), ixy
for my $x (qw( IX IY )) {
	for my $inc (0, 1, 2) {
		$test_nr++;
		
		my $var_label = "L${test_nr}_var";
		my $ldihl = ("ld (hl)", "ld (hl+)", "ldi (hl)")[$inc];
		my $exp_incr = $inc==0 ? 0 : 2;
		
		$ticks->add(<<END, 
					jr start
			var:	defw 0
			start:
			IF !__CPU_INTEL__ && !__CPU_GBZ80__
					ld de, 0x5678
					ld hl, var

					ld $x, 0x1234
					$ldihl, $x
					
					ld bc, (var)
			ELSE
					ld hl, var
					ld de, $exp_incr
					add hl, de
					ld de, 0x5678
					ld bc, 0x1234
			ENDIF
END
			HL 	=> sub { my($t) = @_; return $t->{labels}{$var_label}+$exp_incr; },
			DE 	=> 0x5678,
			BC  => 0x1234);
	}
}

# ld ixy, (hl)
for my $x (qw( IX IY )) {
	for my $inc (0, 1, 2) {
		$test_nr++;
		
		my $var_label = "L${test_nr}_var";
		my $ld =  ("ld",   "ld",    "ldi" )[$inc];
		my $ihl = ("(hl)", "(hl+)", "(hl)")[$inc];
		my $exp_incr = $inc==0 ? 0 : 2;

		$ticks->add(<<END, 
					jr start
			var:	defw 0x1234
			start:
			IF !__CPU_INTEL__ && !__CPU_GBZ80__
					ld de, 0x5678
					ld hl, var
					ld $x, 0
					
					$ld $x, $ihl
					
					ld bc, $x
			ELSE
					ld hl, var
					ld de, $exp_incr
					add hl, de
					ld de, 0x5678
					ld bc, 0x1234
			ENDIF
END
			HL 	=> sub { my($t) = @_; return $t->{labels}{$var_label}+$exp_incr; },
			DE 	=> 0x5678,
			BC	=> 0x1234);
	}
}


$ticks->run;

unlink_testfiles();
done_testing();
