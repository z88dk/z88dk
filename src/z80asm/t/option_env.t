#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test Z80ASM environment variable

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

unlink_testfiles();
spew("test.asm", "jp ASMPC");
delete $ENV{Z80ASM};
run("z80asm -b test.asm");
check_bin_file("test.bin", "\xC3\x00\x00");

$ENV{Z80ASM} = "-r0x8000";
run("z80asm -b test.asm");
check_bin_file("test.bin", "\xC3\x00\x80");

delete $ENV{Z80ASM};

unlink_testfiles();
done_testing();
