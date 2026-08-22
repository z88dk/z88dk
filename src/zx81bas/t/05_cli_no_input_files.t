BEGIN { use lib 't'; require 'testlib.pl'; }

# no input files error if options are supplied but no files
my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");
capture_nok( "build/Debug/z88dk-zx81bas -v", "$dir/expected/$self.txt" );

unlink_testfiles;
done_testing;
