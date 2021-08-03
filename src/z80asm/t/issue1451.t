#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/

use strict;
use warnings;
use Test::More;

my $got_zsdcc = `which z88dk-zsdcc 2> /dev/null`;
if (!$got_zsdcc) {
    diag("z88dk-zsdcc not found, test skipped");
    ok 1;
}
else {
    my $dir = "t/1451";
    my $cmd = "zcc +zxn -startup=4 -clib=sdcc_iy $dir/hexdump.c -subtype=dotn -create-app";
    ok 0==system($cmd), $cmd;

    unlink "A", "a_CODE.bin", "a_MAIN.bin", "a_UNASSIGNED.bin", "zcc_opt.def";
}

done_testing();
