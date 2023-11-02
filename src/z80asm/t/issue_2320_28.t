#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2320
# z80asm: do not link with object files built for a different cpu


# check actual swapping

unlink_testfiles;
for my $code_ixiy ("", "-IXIY", "-IXIY-soft") {
	spew("$test.asm", <<'END');
			ld ix, 0
END
	unlink("$test.bin");
	capture_ok("z88dk-z80asm -b $code_ixiy $test.asm", "");
	ok -f "$test.bin", "$test.bin created";
	my %PREFIX = (""=>0xDD, "-IXIY"=>0xFD, "-IXIY-soft"=>0xFD);
	check_bin_file("$test.bin", bytes($PREFIX{$code_ixiy}, 0x21, 0, 0));
}

unlink_testfiles;
done_testing;
