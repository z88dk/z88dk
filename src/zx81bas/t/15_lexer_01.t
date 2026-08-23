BEGIN { use lib 't'; require 'testlib.pl'; }

my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");

capture_ok( "build/Debug/z88dk-zx81bas -d 4 $dir/input/$self.bas",
    "$dir/expected/$self.txt" );

unlink_testfiles;
done_testing;
