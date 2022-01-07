#!/usr/bin/perl

#-----------------------------------------------------------------------------
# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2022
# License: http://www.perlfoundation.org/artistic_license_2_0
#
# Test https://github.com/z88dk/z88dk/issues/525
# z80asm: single star in path should glob into list of directories
#-----------------------------------------------------------------------------

use Modern::Perl;
use Test::More;
use Path::Tiny;
require './t/testlib.pl';

unlink_testfiles();
-d "test_dir" && path("test_dir")->remove_tree;

path("test_dir/a/1")->mkpath;
path("test_dir/a/2")->mkpath;
path("test_dir/b/1")->mkpath;
path("test_dir/b/2")->mkpath;

path("test_dir/a/1/a.asm")->spew("defb 1");
path("test_dir/a/2/a.asm")->spew("defb 2");
path("test_dir/b/1/a.asm")->spew("defb 3");
path("test_dir/b/2/a.asm")->spew("defb 4");

unlink "test.bin";
run("./z88dk-z80asm -b -otest.bin \"test_dir/**/*\"", 0, "", "");
check_bin_file("test.bin", pack("C*", 1..4));

unlink "test.bin";
run("./z88dk-z80asm -b -otest.bin \"test_dir/*/*/*.asm\"", 0, "", "");
check_bin_file("test.bin", pack("C*", 1..4));

unlink "test.bin";
run("./z88dk-z80asm -b -otest.bin \"test_dir/**/*.asm\"", 0, "", "");
check_bin_file("test.bin", pack("C*", 1..4));

path("test_dir")->remove_tree;
unlink_testfiles();
done_testing();
