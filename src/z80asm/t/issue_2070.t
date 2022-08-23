#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# https://github.com/z88dk/z88dk/issues/2070
# z80asm - continue assembly next files after errors

unlink_testfiles;

# file 1 with errors
spew("${test}1.asm", "jr");

# file 2 ok
spew("${test}2.asm", "nop");

# file 3 with errors
spew("${test}3.asm", "djnz");

# try to assemble and link all three 
capture_nok("z88dk-z80asm -b ${test}1.asm ${test}2.asm ${test}3.asm", <<END);
test_t_issue_20701.asm:1: error: syntax error
  ^---- jr
test_t_issue_20703.asm:1: error: syntax error
  ^---- djnz
END

ok -f "${test}2.o", "file ${test}2.o exists";
ok !-f "${test}1.bin", "file ${test}1.bin not created";

unlink_testfiles;
done_testing;
