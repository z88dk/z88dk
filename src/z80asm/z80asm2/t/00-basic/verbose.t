BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

my $self = path($0)->basename(".t");
capture_ok(
    "z88dk-z80asm -v -dump-after-cmdline t/00-basic/input/empty.asm",
    "t/00-basic/expected/$self.txt"
);

unlink_testfiles;
done_testing;
