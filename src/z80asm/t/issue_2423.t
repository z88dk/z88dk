#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

for my $cou ('mez80', 'ez80_z80') {
	spew("$test.asm", <<END);
		ld.lis bc, 0x1234
		ld.lis de, 0x1234
		ld.lis hl, 0x1234
		ld.lis sp, 0x1234
		ld.lis ix, 0x1234
		ld.lis iy, 0x1234
END

	capture_ok("z88dk-z80asm -mez80_z80 -l -b $test.asm", "");
	check_bin_file("$test.bin", bytes(
		0x49, 0x01, 0x34, 0x12,
		0x49, 0x11, 0x34, 0x12,
		0x49, 0x21, 0x34, 0x12,
		0x49, 0x31, 0x34, 0x12,
		0x49, 0xDD, 0x21, 0x34, 0x12,
		0x49, 0xFD, 0x21, 0x34, 0x12));
}

unlink_testfiles;
done_testing;


