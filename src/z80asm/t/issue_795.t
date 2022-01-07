#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2022
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/795
# Missing .lst file within lst file doesn't error

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

unlink_testfiles();

spew("test1.asm", "defb 1");
spew("test2.asm", "defb 2");
spew("test1.lst", <<'...');
test1.asm
@test2.lst
test2.asm
...
unlink "test2.lst";

run('./z88dk-z80asm -b -otest.bin "@test1.lst"', 1, '', <<'...');
test1.lst:2: error: file open: test2.lst
  ^---- @test2.lst
...


spew("test1.lst", <<'...');
test1.asm
@test2*.lst
test2.asm
...
unlink "test2.lst";

run('./z88dk-z80asm -b -otest.bin "@test1.lst"', 1, '', <<'...');
test1.lst:2: error: pattern returned no files: test2*.lst
  ^---- @test2*.lst
...

unlink_testfiles();
done_testing();
