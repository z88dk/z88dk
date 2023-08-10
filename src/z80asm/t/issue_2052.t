#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# https://github.com/z88dk/z88dk/issues/2052
# z80asm: fails to detect invalid .o file and tries to link it

# invalid .o
for my $opts ('', '-d') {
	for my $ext ('', '.asm', '.o') {
		unlink_testfiles;
		spew("${test}.asm", "nop");
		if ($ext eq '.o') {
			capture_nok("z88dk-z80asm ${test}${ext}", <<END);
error: file not found: test_t_issue_2052.o
END
		}
		else {
			capture_ok("z88dk-z80asm ${test}${ext}", "");
			ok -f "${test}.o", "${test}.o exists";
		
			spew("${test}.o", "rubbish");	# make .o invalid
			sleep(1);
			spew("${test}.asm", "nop");		# touch .asm
			
			capture_ok("z88dk-z80asm -b ${opts} ${test}${ext}", "");
			check_bin_file("${test}.bin", bytes(0));
		}
	}
}

# asm file without extension
unlink_testfiles;
spew("${test}", "nop");
capture_ok("z88dk-z80asm -b ${test}", "");
ok -f "${test}.o", "${test}.o exists";
check_bin_file("${test}.bin", bytes(0));

unlink_testfiles;
done_testing;
