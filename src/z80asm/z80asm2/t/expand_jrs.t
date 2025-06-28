#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

append_out("expand single jump");
for my $distance (126..129) {
	append_out("Distance $distance\n");
	
	open(my $fh, ">", "$test.asm") or die "open $test.asm: $!";
	say $fh "jr next";
	say $fh "nop" for 1..$distance;
	say $fh "next:";
	close($fh);

	run_ok("$exec -v $test.asm >> $test.out 2>&1");
	run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");

	append_out("\n");
}
append_out("\n");


append_out("expand multiple jumps");
open(my $fh, ">", "$test.asm") or die "open $test.asm: $!";
say $fh "prev:";
say $fh "jr next\njr prev" for 1..132/4;
say $fh "next:";
close($fh);

run_ok("$exec -v $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
