BEGIN { use lib 't'; require 'testlib.pl'; }

my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");

copy( "$dir/input/input.bas", "$test.bas" );
capture_ok( "build/Debug/z88dk-zx81bas -d 7 $test.bas",
    "$dir/expected/$self.txt" );

unlink_testfiles;
done_testing;
