#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2022
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/673
# z80asm: MODULE directive cannot accept names that coincide with register or flag names

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

unlink_testfiles();

z80asm(<<'...');
	module a
	section a
	defb 1
	section b
	defb 2
...
check_bin_file("test.bin", pack("C*", 1..2));
z80nm("test.o", <<'...');
Object  file test.o at $0000: Z80RMF16
  Name: a
  Section a: 1 bytes
    C $0000: 01
  Section b: 1 bytes
    C $0000: 02
...

unlink_testfiles();
done_testing();
