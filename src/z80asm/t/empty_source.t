#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# empty input file
z80asm_ok("", "", "", "", "");

capture_ok("z88dk-z80nm -a ${test}.o", <<END);
Object  file ${test}.o at \$0000: Z80RMF16
  Name: ${test}
END

# empty section
spew("${test}.asm", <<'END');
	section CODE
	org 0
	ret
	
	section DATA
	org $8000
	defb 0
	
	section BSS
	org -1
END

capture_ok("z88dk-z80asm -b ${test}.asm", "");

check_bin_file("${test}.bin", "");
check_bin_file("${test}_CODE.bin", bytes(0xC9));
check_bin_file("${test}_DATA.bin", bytes(0));
ok ! -f "${test}_BSS.bin", "${test}_BSS.bin not created";

unlink_testfiles;
done_testing;
