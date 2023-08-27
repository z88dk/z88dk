#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/233
# z80asm: force the name of the output file to use section names with defined ORG

path("${test}.asm")->spew(<<END);
	section code
	org 0x100
	ld hl, (var)
	ret
	
	section data
	org 0x4000
	
	section user_data
var: defw 0x1234
END

capture_ok("z88dk-z80asm -l -b ${test}.asm", "");

check_bin_file("${test}_code.bin", bytes(0x2A,0x00,0x40,0xC9));
check_bin_file("${test}_data.bin", words(0x1234));

unlink_testfiles;
done_testing;
