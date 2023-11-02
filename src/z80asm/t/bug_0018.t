#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# BUG_0018: stack overflow in '@' includes - wrong range check
my $levels = 64;

spew("$test.lst", "\@$test.0.lst");

my $bin = "";
for my $n (0 .. $levels) {
	my $n1 = $n+1;
	spew("$test.$n.lst", <<END);
		$test.$n.asm
		\@$test.$n1.lst
END
	spew("$test.$n.asm", <<END);
		defb $n
END
	$bin .= bytes($n);
}
spew("$test.".($levels+1).".lst", "");

run_ok("z88dk-z80asm -b -o$test.bin \"\@$test.lst\"");

check_bin_file("$test.bin", $bin);

unlink_testfiles;
done_testing;
