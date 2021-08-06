#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

# CH_0012 : wrappers on OS calls to raise fatal error

unlink "${test}.asm";
capture_nok("./z88dk-z80asm ${test}.asm", <<END);
Error: cannot read file '${test}.asm'
END

unlink "${test}.inc";
z80asm_nok("", "", <<END,
    INCLUDE "${test}.inc"
END
           <<END);
Error at file '${test}.asm' line 1: cannot read file '${test}.inc'
END

unlink "${test}.bin";
z80asm_nok("", "", <<END,
    BINARY "${test}.bin"
END
           <<END);
Error at file '${test}.asm' line 1: cannot read file '${test}.bin'
END

unlink "${test}.lib";
z80asm_nok("-b -l${test}", "", <<END,
    NOP
END
           <<END);
Error: cannot read file '${test}.lib'
END

unlink_testfiles;
done_testing;
