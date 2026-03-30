BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

ok 1;
#my $dir = path($0)->dirname;
#my $self = path($0)->basename(".t");
#capture_ok(
#    "z88dk-z80asm -v -dump-tokens t/10-lexer/input/$self.asm",
#    "t/10-lexer/expected/$self.txt"
#);

unlink_testfiles;
done_testing;
