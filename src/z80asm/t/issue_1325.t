#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/1325
# z80asm: Reject invalid instruction bit 0, ixh

use Modern::Perl;
use Test::More;
use Path::Tiny;
require './t/testlib.pl';

unlink_testfiles();

my $bit = 0;
for my $op (qw( bit res set )) {
	for my $r (qw( ixh ixl iyh iyl )) {
		z80asm("$op $bit, $r",	'-b', 1, "", <<END);
test.asm:1: error: syntax error
  ^---- $op $bit, $r
END
		$bit++;
		$bit &= 0x07;
	}
}

unlink_testfiles();
done_testing();
