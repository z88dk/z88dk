BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

note "preprocess .asm.cpp in -Itest.dir path";
path("$test.dir")->remove_tree;
mkdir("$test.dir");

path("$test.dir/$test.asm.cpp")->spew("#define OP nop\nOP");

my $dir = path($0)->dirname;
my $self = path($0)->basename(".t");
capture_ok(
    "z88dk-z80asm -v -I$test.dir -dump-after-cmdline $test.asm.cpp",
    "$dir/expected/$self.txt"
);

path("$test.dir")->remove_tree;
unlink_testfiles;
done_testing;
