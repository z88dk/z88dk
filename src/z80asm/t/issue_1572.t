#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/1572
# z80asm: -reloc-info adds -O directory path twice

use Modern::Perl;
use Test::More;
use Path::Tiny;
require './t/testlib.pl';

unlink_testfiles();
-d "test_dir" and path("test_dir")->remove_tree;
path("test_dir")->mkpath;
z80asm(<<END, "-Otest_dir -b -reloc-info -g -m -l test.asm", 0, "", "");
		start:
			nop
			jp start
END
ok -f "test_dir/test.bin", "test_dir/test.bin created";
ok -f "test_dir/test.lis", "test_dir/test.bin created";
ok -f "test_dir/test.map", "test_dir/test.bin created";
ok -f "test_dir/test.def", "test_dir/test.bin created";
ok -f "test_dir/test.o", "test_dir/test.bin created";
ok -f "test_dir/test.reloc", "test_dir/test.bin created";

path("test_dir")->remove_tree;
unlink_testfiles();
done_testing();
