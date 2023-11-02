#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# BUG_0013: defm check for MAX_CODESIZE incorrect

z80asm_ok("", "", "", <<END, 'a' x 65536);
        defs 65535, 'a'
        defm "a"
END

z80asm_nok("", "", <<END, <<END);
        defs 65535, 'a'
        defm "aa"
END
$test.asm:2: error: segment overflow
  ^---- defm "aa"
END

unlink_testfiles;
done_testing;
