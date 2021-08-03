#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/835
# z80asm - ELIF assembly directive
# Also: test IF et al

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

unlink_testfiles();

my @cond = ('', '-DONE', '-DTWO', '-DTHREE');

# chained IF/ELSE IF
spew("test.asm", <<'...');
	if ONE
		defb 1
	else
		if TWO
			defb 2
		else
			if THREE
				defb 3
			else
				defb 0
			endif
		endif
	endif
...

for (0..$#cond) {
	run("./z88dk-z80asm -b $cond[$_] test.asm", 0, '', '');
	check_bin_file("test.bin", pack("C*", $_));
}

# IF/ELIF
spew("test.asm", <<'...');
	if ONE
		defb 1
	elif TWO
		defb 2
	elif THREE
		defb 3
	else
		defb 0
	endif
...

for (0..$#cond) {
	run("./z88dk-z80asm -b $cond[$_] test.asm", 0, '', '');
	check_bin_file("test.bin", pack("C*", $_));
}

# chained IFDEF/ELSE IFDEF
spew("test.asm", <<'...');
	ifdef ONE
		defb 1
	else
		ifdef TWO
			defb 2
		else
			ifdef THREE
				defb 3
			else
				defb 0
			endif
		endif
	endif
...

for (0..$#cond) {
	run("./z88dk-z80asm -b $cond[$_] test.asm", 0, '', '');
	check_bin_file("test.bin", pack("C*", $_));
}

# IF/ELIFDEF
spew("test.asm", <<'...');
	ifdef ONE
		defb 1
	elifdef TWO
		defb 2
	elifdef THREE
		defb 3
	else
		defb 0
	endif
...

for (0..$#cond) {
	run("./z88dk-z80asm -b $cond[$_] test.asm", 0, '', '');
	check_bin_file("test.bin", pack("C*", $_));
}


@cond = (
	'-DONE -DTWO -DTHREE', 
	'      -DTWO -DTHREE', 
	'-DONE       -DTHREE', 
	'-DONE -DTWO        ');

# chained IFNDEF/ELSE IFNDEF
spew("test.asm", <<'...');
	ifndef ONE
		defb 1
	else
		ifndef TWO
			defb 2
		else
			ifndef THREE
				defb 3
			else
				defb 0
			endif
		endif
	endif
...

for (0..$#cond) {
	run("./z88dk-z80asm -b $cond[$_] test.asm", 0, '', '');
	check_bin_file("test.bin", pack("C*", $_));
}

# IF/ELIFNDEF
spew("test.asm", <<'...');
	ifndef ONE
		defb 1
	elifndef TWO
		defb 2
	elifndef THREE
		defb 3
	else
		defb 0
	endif
...

for (0..$#cond) {
	run("./z88dk-z80asm -b $cond[$_] test.asm", 0, '', '');
	check_bin_file("test.bin", pack("C*", $_));
}

unlink_testfiles();
done_testing();
