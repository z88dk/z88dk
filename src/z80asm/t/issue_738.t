#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/738
# z80asm: superfluous section generated in compile
# caused by expressions DEFC aaa = aaa

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

unlink_testfiles();

z80asm(<<'...', "", 1, "", <<'...');
	defc aaa = aaa
...
Error at file 'test.asm' line 1: expression for 'aaa' depends on itself
...

unlink_testfiles();
done_testing();
