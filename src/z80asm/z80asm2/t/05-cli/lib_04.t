BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");

unlink("$test.lib");
capture_ok(
"build/Debug/z88dk-z80asm -v -l$test -dump-after-cmdline $dir/input/empty.asm",
    "$dir/expected/$self.txt"
);

unlink_testfiles;
done_testing;
