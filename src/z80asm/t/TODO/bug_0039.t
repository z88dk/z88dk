#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# test BUG_0039: library not pulled in if PUBLIC symbol not referenced in expression

spew("${test}.asm", <<END);
	EXTERN A51
	defb A51
END

spew("${test}5.asm", <<END);
	PUBLIC A5
	PUBLIC A51
A5:	defc A51 = 51
END

capture_ok("z88dk-z80asm -x${test}5.lib ${test}5.asm", ""); 
ok -f "${test}5.lib";

capture_ok("z88dk-z80asm -l -m -b -l${test}5.lib ${test}.asm", "");
ok -f "${test}.bin";
check_bin_file("${test}.bin", bytes(51));

unlink_testfiles;
done_testing;

