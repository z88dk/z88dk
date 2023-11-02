#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/889
# z80asm: premature range check during calculation of defb

z80asm_ok("", "", "", <<END, "7");
	defc MAIN = 45678
	defb (MAIN - 1) / 10 % 10 + '0'
END

unlink_testfiles;

spew("${test}.asm", <<'END');
	PUBLIC MAIN
	defc MAIN = 45678
END

spew("${test}1.asm", <<'END');
	EXTERN MAIN
	defb (MAIN - 1) / 10 % 10 + '0'
END

capture_ok("z88dk-z80asm -b ${test}.asm ${test}1.asm", "");

check_bin_file("${test}.bin", "7");

unlink_testfiles;
done_testing;
