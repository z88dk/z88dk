#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2019
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/717
# z80asm: sections with ALIGN property should not insert padding if the section is empty

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

unlink_testfiles();

z80asm(<<'...');
	section a
	defb 1
	
	section b
	align 16
	
	section c
	defb 3
...
check_bin_file("test.bin", pack("C*", 1, 3));


z80asm(<<'...');
	section a
	defb 1
	
	section b
	align 16
	defb 2
	
	section c
	defb 3
...
check_bin_file("test.bin", pack("C*", 1, (0) x 15, 2, 3));


unlink_testfiles();
done_testing();
