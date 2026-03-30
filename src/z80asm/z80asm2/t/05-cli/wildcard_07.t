BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

my $dir = path($0)->dirname;
my $self = path($0)->basename(".t");

$ENV{TEST} = "$dir/input/wildcard";
capture_ok(
    "z88dk-z80asm -v -dump-after-cmdline \@$dir/input/$self.lst",
    "$dir/expected/$self.txt"
);

unlink_testfiles;
done_testing;
