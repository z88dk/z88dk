BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

my $self = path($0)->basename(".t");
my $options = path("t/05-expr/input/$self.txt")->slurp =~ s/\s+/ /gr;
capture_ok(
    "z88dk-z80asm $options -dump-after-cmdline t/05-expr/input/empty.asm",
    "t/05-expr/expected/$self.txt"
);

unlink_testfiles;
done_testing;
