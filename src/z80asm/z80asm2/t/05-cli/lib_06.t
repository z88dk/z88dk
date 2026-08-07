BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");

path("$test.dir/dir1")->mkdir;
path("$test.dir/dir2")->mkdir;
path("$test.dir/dir1/lib1.lib")->spew("");
path("$test.dir/dir2/lib1.lib")->spew("");

capture_ok(
"build/Debug/z88dk-z80asm -v -llib1 -L$test.dir/dir1 -L$test.dir/dir2 -dump-after-cmdline $dir/input/empty.asm",
    "$dir/expected/$self.txt"
);
path("$test.dir")->remove_tree;

unlink_testfiles;
done_testing;
