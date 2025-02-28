#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

for my $rst (0, 8, 0x30) {
	my $rst_hex = ($rst < 10) ? $rst : sprintf("\$%02X", $rst);
	spew("$test.asm", <<END);
rst $rst
END

	for my $cpu ('r2ka', 'r3k', 'r4k', 'r5k') {
		capture_nok("z88dk-z80asm -m$cpu -l -b $test.asm", <<END);
$test.asm:1: error: integer range: $rst_hex
  ^---- rst $rst
END
	}
}

for my $rst (0x10, 0x18, 0x20, 0x28, 0x38) {
	spew("$test.asm", <<END);
		rst $rst
END

	for my $cpu ('r2ka', 'r3k', 'r4k', 'r5k') {
		capture_ok("z88dk-z80asm -m$cpu -l -b $test.asm", "");
		check_bin_file("$test.bin", bytes(0xC7+$rst));
	}
}

unlink_testfiles;
done_testing;


