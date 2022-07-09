#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# -o

# no -o
unlink_testfiles;
spew("${test}.asm", "nop");
run_ok("z88dk-z80asm -b ${test}.asm");
ok -f "${test}.bin", "binary file";
check_bin_file("${test}.bin", bytes(0));

# -o
unlink_testfiles;
spew("${test}.asm", "nop");
run_ok("z88dk-z80asm -b -o${test}2.bin ${test}.asm");
ok !-f "${test}.bin", "no default binary file";
ok -f "${test}2.bin", "new binary file";
check_bin_file("${test}2.bin", bytes(0));

# -o without extension
unlink_testfiles;
spew("${test}.asm", "nop");
run_ok("z88dk-z80asm -b -o${test}2 ${test}.asm");
ok !-f "${test}.bin", "no default binary file";
ok -f "${test}2", "new binary file";
check_bin_file("${test}2", bytes(0));

# -o with extension != .bin
unlink_testfiles;
spew("${test}.asm", "nop");
run_ok("z88dk-z80asm -b -o${test}.sms ${test}.asm");
ok !-f "${test}.bin", "no default binary file";
ok -f "${test}.sms", "new binary file";
check_bin_file("${test}.sms", bytes(0));

# output with sections
my $asm = <<END;
	section code
	org 0
	ret
	
	section data
	org 0x8000
	defb 1
END

# no -o
unlink_testfiles;
spew("${test}.asm", $asm);
run_ok("z88dk-z80asm -b ${test}.asm");
check_bin_file("${test}.bin", bytes());
check_bin_file("${test}_code.bin", bytes(0xC9));
check_bin_file("${test}_data.bin", bytes(1));

# -o without extension
unlink_testfiles;
spew("${test}.asm", $asm);
run_ok("z88dk-z80asm -b -o${test}xx ${test}.asm");
ok !-f "${test}.bin", "no default binary file";
check_bin_file("${test}xx", bytes());
check_bin_file("${test}xx_code.bin", bytes(0xC9));
check_bin_file("${test}xx_data.bin", bytes(1));

# -o with extension != .bin
unlink_testfiles;
spew("${test}.asm", $asm);
run_ok("z88dk-z80asm -b -o${test}xx.sms ${test}.asm");
ok !-f "${test}.bin", "no default binary file";
check_bin_file("${test}xx.sms", bytes());
check_bin_file("${test}xx_code.bin", bytes(0xC9));
check_bin_file("${test}xx_data.bin", bytes(1));

# test -o with environment variables
unlink_testfiles;
$ENV{TEST_ENV} = '2.bin';
spew("${test}.asm", "nop");
run_ok("z88dk-z80asm -b -o${test}\${TEST_ENV} ${test}.asm");
ok !-f "${test}.bin", "no default binary file";
ok -f "${test}2.bin", "new binary file";
check_bin_file("${test}2.bin", bytes(0));

unlink_testfiles;
delete $ENV{TEST_ENV};
spew("${test}.asm", "nop");
run_ok("z88dk-z80asm -b -o${test}\${TEST_ENV}2.bin ${test}.asm");
ok !-f "${test}.bin", "no default binary file";
ok -f "${test}2.bin", "new binary file";
check_bin_file("${test}2.bin", bytes(0));

unlink_testfiles;
done_testing;
