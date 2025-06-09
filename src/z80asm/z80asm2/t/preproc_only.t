#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

path("$test.asm")->spew(<<END);
line 1 ; comment
; comment

line 4:statement 2\\statement 3;comment
include "$test.inc"
line 6
END

path("$test.inc")->spew(<<END);
inc line 1 ; comment
; comment

inc \\
line \\
6
END

run_ok("$exec -E $test.asm > $test.out 2>&1");
run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
