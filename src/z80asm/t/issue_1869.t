#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# https://github.com/z88dk/z88dk/issues/1869
# z80asm: assertion failed in modlink.c:512

z80asm_nok("", "", <<END_ASM, <<END_ERR);
        defc    i_64 = i_61
        defc    i_61 = i_64
END_ASM
$test.asm:1: error: undefined symbol: i_64
  ^---- i_61
$test.asm:2: error: undefined symbol: i_61
  ^---- i_64
END_ERR

spew("$test.1.asm", <<END_ASM);
        public  i_64
        extern  i_61
        defc    i_64 = i_61
END_ASM

spew("$test.2.asm", <<END_ASM);
        public  i_61
        extern  i_64
        defc    i_61 = i_64
END_ASM

capture_nok("z88dk-z80asm -b $test.1.asm $test.2.asm", <<END_ERR);
$test.1.asm:3: error: undefined symbol: i_64
  ^---- i_61
$test.2.asm:3: error: undefined symbol: i_61
  ^---- i_64
END_ERR

unlink_testfiles;
done_testing;
