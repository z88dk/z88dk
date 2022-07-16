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
