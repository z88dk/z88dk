BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

note "preprocess .asm.cpp";
path("$test.asm.cpp")->spew("#define OP nop\nOP");

my $dir = path($0)->dirname;
my $self = path($0)->basename(".t");
capture_ok(
    "z88dk-z80asm -v -dump-after-cmdline $test.asm.cpp",
    "$dir/expected/$self.txt"
);

unlink_testfiles;
done_testing;
