#!/usr/bin/perl

#-----------------------------------------------------------------------------
# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2020
# License: http://www.perlfoundation.org/artistic_license_2_0
#
# Test https://github.com/z88dk/z88dk/issues/761
# z80asm: always crashes with vs2015 binaries
#-----------------------------------------------------------------------------

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

unlink_testfiles();

mkdir("test_dir");

run("z80asm -b -Itest_dir f_not_found.asm", 1, "", <<'...');
Error: cannot read file 'f_not_found.asm'
...

unlink_testfiles();
done_testing();
