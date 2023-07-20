#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# https://github.com/z88dk/z88dk/issues/1920
# z80asm: Is #define with conditionals supported?

z80asm_ok("", "", "", <<'END', bytes(0x3e, 2, 0x3e, 1));
        #define ONEBITOUT(x)  \
        IF x                \ \
            ld a, 1         \ \
        ELSE                \ \
            ld a, 2         \ \
        ENDIF
        ONEBITOUT(0)
        ONEBITOUT(1)        
END

unlink_testfiles;
done_testing;
