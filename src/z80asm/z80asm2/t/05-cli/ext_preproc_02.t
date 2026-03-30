BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

note "preprocess .asm.pl, pass perl options";
path("$test.asm.pl")->spew("print 'nop';");

my $dir = path($0)->dirname;
my $self = path($0)->basename(".t");
capture_ok(
    "z88dk-z80asm -v -perl=-w -perl=-Mstrict -dump-after-cmdline $test.asm.pl",
    "$dir/expected/$self.txt"
);

unlink_testfiles;
done_testing;
