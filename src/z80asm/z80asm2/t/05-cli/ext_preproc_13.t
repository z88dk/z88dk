BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

note "preprocess .asm.m4 in -Itest.dir path";
path("$test.dir")->remove_tree;
mkdir("$test.dir");

path("$test.dir/$test.asm.m4")->spew("define(`OP', `nop') OP");

my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");
capture_ok( "z88dk-z80asm -v -I$test.dir -dump-after-cmdline $test.asm.m4", "$dir/expected/$self.txt" );

path("$test.dir")->remove_tree;
unlink_testfiles;
done_testing;
