BEGIN { use lib 't'; require 'testlib.pl'; }

# All help aliases must produce identical usage output
for my $help ('-h', '--help', '-?') {
	capture_ok("z88dk-z80asm $help", "t/00-basic/expected/usage.txt");
}

unlink_testfiles;
done_testing;
