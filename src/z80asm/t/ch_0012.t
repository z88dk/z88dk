#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# CH_0012 : wrappers on OS calls to raise fatal error

unlink "$test.asm";
capture_nok("z88dk-z80asm $test.asm", <<END);
error: file open: $test.asm
END

unlink "$test.inc";
z80asm_nok("", "", <<END_ASM, <<END_ERR);
    INCLUDE "$test.inc"
END_ASM
$test.asm:1: error: file open: $test.inc
  ^---- INCLUDE "$test.inc"
END_ERR

unlink "$test.bin";
z80asm_nok("", "", <<END_ASM, <<END_ERR);
    BINARY "$test.bin"
END_ASM
$test.asm:1: error: file open: $test.bin
  ^---- BINARY "$test.bin"
END_ERR

unlink "$test.lib";
z80asm_nok("-b -l$test", "", <<END_ASM, <<END_ERR);
    NOP
END_ASM
error: file open: $test.lib
END_ERR

unlink_testfiles;
done_testing;
