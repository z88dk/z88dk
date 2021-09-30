#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

# z80asm: assertion failed in modlink.c:512
# https://github.com/z88dk/z88dk/issues/1869

z80asm_nok("", "", <<END_ASM, <<END_ERR);
        defc    i_64 = i_61
        defc    i_61 = i_64
END_ASM
Error at file '$test.asm' line 1: symbol 'i_64' not defined
Error at file '$test.asm' line 2: symbol 'i_61' not defined
END_ERR

path("$test.1.asm")->spew(<<END_ASM);
        public  i_64
        extern  i_61
        defc    i_64 = i_61
END_ASM

path("$test.2.asm")->spew(<<END_ASM);
        public  i_61
        extern  i_64
        defc    i_61 = i_64
END_ASM

capture_nok("./z88dk-z80asm -b $test.1.asm $test.2.asm", <<END_ERR);
Error at file '$test.1.asm' line 3: symbol 'i_64' not defined
Error at file '$test.2.asm' line 3: symbol 'i_61' not defined
END_ERR

unlink_testfiles;
done_testing;
