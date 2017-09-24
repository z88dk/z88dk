#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/341
# z80asm: Produce a debugger-friendly filename/bank/memory address file

use strict;
use warnings;
use v5.10;

use Test::More;

require './t/testlib.pl';

unlink_testfiles();
spew("test1.asm", <<END);
	public func
func:
	ret
END

spew("test.c", <<END);
int add(int a, int b) 
{
	return a+b;
}

int main()
{
	int a = 4;
	int b = 6;
	int s = add(a,b);
	return s;
}
END

run("zcc +z80 -m --list -Cc-gcline -Ca--debug -no-cleanup test.c test1.asm -otest.bin", 0, 'IGNORE', '');
#run("sccz80 -mz80 -gcline test.c test1.asm", 0, 'IGNORE', '');
#ok -f "test.asm";
#run("z80asm -m --debug test.asm test1.c");
#


#run("zcc +z80 -m --list -gcline -Ca--debug -no-cleanup test.c test1.asm -otest.bin", 0, 'IGNORE', '');

#unlink_testfiles();
done_testing();
