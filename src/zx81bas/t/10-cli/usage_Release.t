BEGIN { use lib 't'; require 'testlib.pl'; }

# All help aliases must produce identical usage output
my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");
capture_ok( "build/Release/z88dk-zx81bas -h", "$dir/expected/$self.txt" );

unlink_testfiles;
done_testing;
