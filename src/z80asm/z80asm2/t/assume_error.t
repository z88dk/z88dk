#!/usr/bin/env perl

use Modern::Perl;
use Test::More;
use Path::Tiny;

my $exec = $^O =~ /MSWin32|msys/ ? "./z80asm.exe" : "./z80asm";
my $test = "test_".path($0)->basename(".t");
my $bmk = "t/".path($0)->basename(".t").".bmk";


path("$test.asm")->spew(<<END);
	; .ASSUME
	.Assume ASMPC*0:.Assume \$/\$
END

run_nok("$exec $test.asm > $test.out 2>&1");
run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();


sub run_ok {
	note "@_";
	ok 0==system("@_");
}

sub run_nok {
	note "@_";
	ok 0!=system("@_");
}

sub unlink_testfiles {
	unlink(<$test.*>) if Test::More->builder->is_passing;	
}
