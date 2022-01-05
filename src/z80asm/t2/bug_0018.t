#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

# BUG_0018: stack overflow in '@' includes - wrong range check
my $levels = 64;

path("$test.lst")->spew("\@$test.0.lst");

my $bin = "";
for my $n (0 .. $levels) {
	my $n1 = $n+1;
	path("$test.$n.lst")->spew(<<END);
		$test.$n.asm
		\@$test.$n1.lst
END
	path("$test.$n.asm")->spew(<<END);
		defb $n
END
	$bin .= bytes($n);
}
path("$test.".($levels+1).".lst")->spew("");

run_ok("./z88dk-z80asm -b -o$test.bin \"\@$test.lst\"");

check_bin_file("$test.bin", $bin);

unlink_testfiles;
done_testing;
