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

for my $dd (qw( BC DE HL SP )) {
	$test_nr++;
	my $var_label = "L${test_nr}_var";
	
	$ticks->add(<<END,
					jp start
			var:	defw 0
			start:
					ld $dd, 0x1234
					ld (var), $dd
END
		$dd => sub { my($t) = @_;
					local $Test::Builder::Level = $Test::Builder::Level + 1;
					my $var_addr = $t->{labels}{$var_label};
					my $var_value = $t->{mem}[$var_addr] + ($t->{mem}[$var_addr+1] << 8);
					is $var_value, 0x1234, "var";
					return 0x1234; });
}

$ticks->run;

unlink_testfiles();
done_testing();
