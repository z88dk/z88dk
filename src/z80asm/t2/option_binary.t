#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

# -b

# no -b
unlink_testfiles;
path("${test}.asm")->spew("nop");
run_ok("./z88dk-z80asm ${test}.asm");
ok -f "${test}.o", "object file";
ok !-f "${test}.bin", "no binary file";

# -b
unlink_testfiles;
path("${test}.asm")->spew("nop");
run_ok("./z88dk-z80asm -b ${test}.asm");
ok -f "${test}.o", "object file";
ok -f "${test}.bin", "binary file";
check_bin_file("${test}.bin", bytes(0));

unlink_testfiles;
done_testing;
