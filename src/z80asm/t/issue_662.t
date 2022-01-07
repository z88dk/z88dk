#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2022
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/662
# z80asm: ALIGN directive not working inside PHASE

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

unlink_testfiles();

z80asm(<<'...');
	defb 1
	align 16
	defb 2
...
check_bin_file("test.bin", pack("C*", 1, (0) x 15, 2));

z80asm(<<'...');
	defb 1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6
	align 16
	defb 2
...
check_bin_file("test.bin", pack("C*", 1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6, 2));

# bug: align disregards org
#z80asm(<<'...', '-b -r2 -m');
#	defb 1
#	align 16
#	defb 2
#...
#check_bin_file("test.bin", pack("C*", 1, (0) x 13, 2));

z80asm(<<'...');
	defb 1
	phase 0x8000
	defb 2,3
	align 16
	defb 4
...
check_bin_file("test.bin", pack("C*", 1, 2,3, (0) x 14, 4));


unlink_testfiles();
done_testing();
