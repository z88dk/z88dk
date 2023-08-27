#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test __head, __tail and __size symbols

my $asm = <<END;
	EXTERN __head, __tail, __size
	
	DEFW __head
	DEFW __tail
	DEFW __size
END

#------------------------------------------------------------------------------
z80asm_ok("-r0x0000 -b", "", "", $asm, words(0x0000,0x0006,0x0006));

#------------------------------------------------------------------------------
z80asm_ok("-r0xF000 -b", "", "", $asm, words(0xF000,0xF006,0x0006));

#------------------------------------------------------------------------------
spew("${test}a.asm", $asm);
spew("${test}b.asm", $asm);

capture_ok("z88dk-z80asm -b -r0x0000 ${test}a.asm ${test}b.asm", "");
check_bin_file("${test}a.bin",
		words(0x0000,0x000C,0x000C,
			  0x0000,0x000C,0x000C));

#------------------------------------------------------------------------------
spew("${test}a.asm", $asm);
spew("${test}b.asm", $asm);

capture_ok("z88dk-z80asm -b -r0xF000 ${test}a.asm ${test}b.asm", "");
check_bin_file("${test}a.bin",
		words(0xF000,0xF00C,0x000C,
			  0xF000,0xF00C,0x000C));

unlink_testfiles;
done_testing;
