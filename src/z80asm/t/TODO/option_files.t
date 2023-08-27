#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# asm extension

for my $file ("${test}", "${test}.asm") {
	unlink_testfiles;
	spew("${test}.asm", "ret");
	capture_ok("z88dk-z80asm -b $file", "");
	check_bin_file("${test}.bin", bytes(0xC9));
}

unlink_testfiles;
spew("${test}.xxx", "ret");
capture_ok("z88dk-z80asm -b ${test}.xxx", "");
check_bin_file("${test}.bin", bytes(0xC9));

# no extension

unlink_testfiles;
spew("${test}.asm", "ret");
capture_ok("z88dk-z80asm -b ${test}", "");
check_bin_file("${test}.bin", bytes(0xC9));

unlink("${test}.bin", "${test}.asm");
capture_ok("z88dk-z80asm -b ${test}", "");
check_bin_file("${test}.bin", bytes(0xC9));

# o extension

unlink_testfiles;
spew("${test}.asm", "ret");
capture_nok("z88dk-z80asm -b ${test}.o", <<END);
error: file not found: test_t_option_files.o
END

unlink("${test}.bin", "${test}.asm");
capture_nok("z88dk-z80asm -b ${test}.o", <<END);
error: file not found: test_t_option_files.o
END

# -- option separator
unlink_testfiles;
spew("-${test}.asm", <<END);
	nop
END

capture_nok("z88dk-z80asm -b -${test}.asm", <<END);
error: illegal option: -${test}.asm
END

capture_ok("z88dk-z80asm -b -- -${test}.asm", "");
is slurp("-${test}.bin"), bytes(0);
unlink(<-${test}.*>);

unlink_testfiles;
done_testing;
