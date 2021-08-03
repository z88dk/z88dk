#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/850
# (z80asm) Doesn't handle empty library files

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

unlink_testfiles();

# not possible to create empty library file
run('./z88dk-z80asm -xtest.lib "test*.asm"', 1, '', <<'...');
Error: pattern 'test*.asm' returned no files
...

# force the error and check behaviour
spew("test.asm", "");
run('./z88dk-z80asm -xtest.lib "test.asm"', 0, '', '');
ok -f "test.lib";
my $bytes = slurp("test.lib");
spew("test.lib", substr($bytes, 0, 8));		# invalid lib, only header

spew("test.asm", <<'...');
	extern main
	jp main
...
run('./z88dk-z80asm -b -ltest.lib test.asm', 1, '', <<'...');
Error at file 'test.asm' line 2: symbol 'main' not defined
...

unlink_testfiles();
done_testing();
