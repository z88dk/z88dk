#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

# BUG_0013: defm check for MAX_CODESIZE incorrect

z80asm_ok("", "", "", <<END, 'a' x 65536);
        defs 65535, 'a'
        defm "a"
END

z80asm_nok("", "", <<END, <<END);
        defs 65535, 'a'
        defm "aa"
END
Error at file '${test}.asm' line 2: max. code size of 65536 bytes reached
END

unlink_testfiles;
done_testing;
