BEGIN { use lib 't'; require 'testlib.pl'; }

# without options output just copyright information
my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");
capture_ok( "z88dk-z80asm", "$dir/expected/$self.txt" );

unlink_testfiles;
done_testing;
