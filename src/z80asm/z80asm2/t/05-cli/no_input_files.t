BEGIN { use lib 't'; require 'testlib.pl'; }

# no input files error if options are supplied but no files
my $dir = path($0)->dirname;
my $self = path($0)->basename(".t");
capture_nok("z88dk-z80asm -v -d", "$dir/expected/$self.txt");

unlink_testfiles;
done_testing;
