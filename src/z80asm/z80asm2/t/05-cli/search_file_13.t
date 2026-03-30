BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

note "file.asm exists, give .asm, -Otest.dir";
path("$test.dir")->remove_tree;
mkdir("$test.dir");

path("$test.asm")->spew("nop");
unlink("$test.dir/$test.o");

my $dir = path($0)->dirname;
my $self = path($0)->basename(".t");
capture_ok(
    "z88dk-z80asm -v -O$test.dir -dump-after-cmdline $test.asm",
    "$dir/expected/$self.txt"
);

path("$test.dir")->remove_tree;
unlink_testfiles;
done_testing;
