#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

my $got_zsdcc = `which z88dk-zsdcc 2> /dev/null`;
if (!$got_zsdcc) {
    diag("z88dk-zsdcc not found, test skipped");
    ok 1;
}
else {
    my $dir = "t2/1451";
	run_ok("zcc +zxn -startup=4 -clib=sdcc_iy $dir/hexdump.c -subtype=dotn -create-app");
    unlink "A", "a.lis", "a_CODE.bin", "a_MAIN.bin", "a_UNASSIGNED.bin", "zcc_opt.def";
}

unlink_testfiles;
done_testing;
