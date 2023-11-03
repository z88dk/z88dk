#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/65
# z80asm: separate BSS section not generated from object file if BSS org was -1 at assembly time

my $asm = <<'END';
	section CODE
	ret
	section DATA
	org 0x4000	; split file here
	defw 0
	section BSS
	org -1	; split file here
	defw 1
END

# compile and link in one step
unlink_testfiles;
spew("${test}.asm", $asm);

capture_ok("z88dk-z80asm -b ${test}.asm", "");

check_bin_file("${test}.bin", 		bytes(0xC9));
check_bin_file("${test}_DATA.bin",	bytes(0x00, 0x00));
check_bin_file("${test}_BSS.bin", 	bytes(0x01, 0x00));


# compile and link in two steps
unlink_testfiles;
spew("${test}.asm", $asm);

capture_ok("z88dk-z80asm ${test}.asm", "");
capture_ok("z88dk-z80asm -b ${test}.o", "");

check_bin_file("${test}.bin", 		bytes(0xC9));
check_bin_file("${test}_DATA.bin",	bytes(0x00, 0x00));
check_bin_file("${test}_BSS.bin", 	bytes(0x01, 0x00));


unlink_testfiles;
done_testing;
