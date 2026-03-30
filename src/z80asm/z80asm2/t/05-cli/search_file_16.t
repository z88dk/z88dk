BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

note "file.o exists, give .o, -Otest.dir";
path("$test.dir")->remove_tree;
mkdir("$test.dir");

unlink("$test.asm");
path("$test.dir/$test.o")->spew("");

my $dir = path($0)->dirname;
my $self = path($0)->basename(".t");
capture_ok(
    "z88dk-z80asm -v -O$test.dir -dump-after-cmdline $test.o",
    "$dir/expected/$self.txt"
);

path("$test.dir")->remove_tree;
unlink_testfiles;
done_testing;
