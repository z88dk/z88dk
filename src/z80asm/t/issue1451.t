#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2019
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/

use strict;
use warnings;
use Test::More;

my $dir = "t/1451";
my $cmd = "zcc +zxn -no-cleanup -startup=4 -clib=sdcc_iy $dir/hexdump.c -o $dir/hexdump -subtype=dotn -create-app";
ok 0==system($cmd), $cmd;

unlink "$dir/H", "$dir/hexdump_CODE.bin", "$dir/hexdump_MAIN.bin", "$dir/hexdump_UNASSIGNED.bin";
done_testing();
