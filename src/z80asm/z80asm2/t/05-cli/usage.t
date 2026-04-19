BEGIN { use lib 't'; require 'testlib.pl'; }

# All help aliases must produce identical usage output
my $dir = path($0)->dirname;
my $self = path($0)->basename(".t");
for my $help ('-h', '--help', '-?') {
	capture_ok("z88dk-z80asm $help", "$dir/expected/$self.txt");
}

unlink_testfiles;
done_testing;
