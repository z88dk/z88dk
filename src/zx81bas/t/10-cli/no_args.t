BEGIN { use lib 't'; require 'testlib.pl'; }

# without options output just copyright information
my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");
capture_ok( "build/Debug/z88dk-zx81bas", "$dir/expected/$self.txt" );

unlink_testfiles;
done_testing;
