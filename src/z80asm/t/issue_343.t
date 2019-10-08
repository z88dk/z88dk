#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2019
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/343
# z80asm: Rabbit emulation of cpi and cpir is broken

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

spew("test.asm",<<END);
		extern __z80asm__cpir
		call   __z80asm__cpir
END

run("z80asm -mz80 -b test.asm");
my $bin1 = hexdump(slurp("test.bin"));
note $bin1;

run("z80asm -mr2k -b test.asm");
my $bin2 = hexdump(slurp("test.bin"));
note $bin2;

isnt $bin1, $bin2, "binary different";


# spew("test.c", <<END);
#include <string.h>
# int main () {
# return strncmp("hello world", "hello", 5);
# }
# END
# run("zcc +test -v -clib=rabbit test.c");

unlink_testfiles();
done_testing();
