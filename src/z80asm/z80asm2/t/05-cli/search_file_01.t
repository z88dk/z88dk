BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

note "file.asm exists, give only stem";
path("$test.asm")->spew("nop");
unlink("$test.o");

my $dir = path($0)->dirname;
my $self = path($0)->basename(".t");
capture_ok(
    "z88dk-z80asm -v -dump-after-cmdline $test",
    "$dir/expected/$self.txt"
);

unlink_testfiles;
done_testing;
