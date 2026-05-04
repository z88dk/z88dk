BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

note "file.o exists, give only stem, -Itest.dir";
path("$test.dir")->remove_tree;
mkdir("$test.dir");

unlink("$test.dir/$test.asm");
path("$test.dir/$test.o")->spew("");

my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");
capture_ok( "z88dk-z80asm -v -I$test.dir -dump-after-cmdline $test", "$dir/expected/$self.txt" );

path("$test.dir")->remove_tree;
unlink_testfiles;
done_testing;
