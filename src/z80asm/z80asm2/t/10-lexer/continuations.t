BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

my $self = path($0)->basename(".t");
capture_ok(
	"z88dk-z80asm -v -dump-after-tokenization t/10-lexer/input/$self.asm",
	"t/10-lexer/expected/$self.txt"
);

unlink_testfiles;
done_testing;
