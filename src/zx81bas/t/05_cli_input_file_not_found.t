BEGIN { use lib 't'; require 'testlib.pl'; }

# without options output just copyright information
my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");
capture_nok( "build/Debug/z88dk-zx81bas $dir/input/$self.bas",
    "$dir/expected/$self.txt" );

unlink_testfiles;
done_testing;
