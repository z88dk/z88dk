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

# ld de, sp+%n
for my $base (0x1000) {
	for my $add (0, 127, 255) {
		my $add_text = $add == 0 ? "" :
								   "+$add";
		my $sum = $base + $add;
		
		$ticks->add(<<END, DE=>$sum);
				ld		sp, $base
				ld      de, sp $add_text
END
	}
}

# ld hl, sp+%s
for my $base (0x1000) {
	for my $add (-128, 0, 127) {
		my $add_text = $add <  0 ? $add :
					   $add == 0 ? "" :
								   "+$add";
		
		$ticks->add(<<END, 
				ld		sp, $base
				ld      hl, sp $add_text
END
			HL => sub { my($t) = @_;
						my $sum;
						if ($t->{cpu} eq '8085') {
							$sum = $base + ($add & 0xff);		# unsigned
						}
						else {
							$sum = $base + $add;				# signed
						}
						return $sum;
			});
	}
}

$ticks->run;

unlink_testfiles();
done_testing();
