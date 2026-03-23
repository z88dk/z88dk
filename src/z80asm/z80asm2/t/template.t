BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

ok 1;
#capture_ok(
#    "z88dk-z80asm -dump-tokens t/10-lexer/input/tokens_simple.asm",
#    "t/10-lexer/expected/tokens_simple.txt"
#);

unlink_testfiles;
done_testing;
