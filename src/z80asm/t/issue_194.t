#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2019
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#
# Test https://github.com/z88dk/z88dk/issues/194
# z80asm: wrong assembly of DDCB with no index

use Modern::Perl;
use Test::More;
require './t/testlib.pl';


unlink_testfiles();
z80asm(<<'END', "-b -s -l");
	rlc (ix+0)
	rlc (ix)
END
check_bin_file("test.bin", pack("C*", (0xDD, 0xCB, 0x00, 0x06) x 2));

unlink_testfiles();
done_testing();
