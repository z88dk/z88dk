#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/1325
# z80asm: Reject invalid instruction bit 0, ixh

my $bit = 0;
for my $op (qw( bit res set )) {
	for my $r (qw( ixh ixl iyh iyl )) {
		z80asm_nok("-b", "", "$op $bit, $r", <<END);
${test}.asm:1: error: syntax error
  ^---- $op $bit, $r
END
		$bit = ($bit+1) & 7;
	}
}

unlink_testfiles;
done_testing;
