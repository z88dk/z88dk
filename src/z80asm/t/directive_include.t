#!/usr/bin/perl

# Z88DK Z80 Module Assembler
#
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test INCLUDE

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

# no -I, multiple levels
unlink_testfiles();
spew("test0.inc", 'ld a,10');
for (1..9) { spew("test$_.inc", 'include "test'.($_-1).'.inc"'."\n defb $_"); }
z80asm(<<END);
		include "test9.inc"
		nop
END
check_bin_file("test.bin", pack("C*", 0x3E, 10, 1..9, 0));

# -I
unlink_testfiles();
mkdir("test_dir");

spew("test_dir/test.inc", 'ld a,10');

# no -I, full path : OK
z80asm('include "test_dir/test.inc"');
check_bin_file("test.bin", pack("C*", 0x3E, 10));

# no -I, only file name : error
z80asm('include "test.inc"', "", 1, "", <<END);
Error at file 'test.asm' line 1: cannot read file 'test.inc'
END
	
# -I : OK
z80asm('include "test.inc"', "-b -Itest_dir");
check_bin_file("test.bin", pack("C*", 0x3E, 10));

# -I, full path : OK
z80asm('include "test_dir/test.inc"', "-b -Itest_dir");
check_bin_file("test.bin", pack("C*", 0x3E, 10));

# directory of source file is added to include path
unlink_testfiles();
mkdir("test_dir");

spew("test_dir/test.inc", 'ld a,10');
spew("test_dir/test.asm", 'include "test.inc"');
run("./z88dk-z80asm -b test_dir/test.asm");
check_bin_file("test_dir/test.bin", pack("C*", 0x3E, 10));

# error_read_file
# BUG_0034 : If assembly process fails with fatal error, invalid library is kept
unlink_testfiles();
z80asm('include "test.inc"', "-xtest.lib", 1, "", <<END);
Error at file 'test.asm' line 1: cannot read file 'test.inc'
END
ok ! -f "test.lib", "test.lib does not exist";

# error_include_recursion
unlink_testfiles();
spew("test.inc", 'include "test.asm"');
z80asm('include "test.inc"', "", 1, "", <<END);
Error at file 'test.inc' line 1: cannot include file 'test.asm' recursively
END

# syntax
unlink_testfiles();
z80asm('include', "", 1, "", <<END);
Error at file 'test.asm' line 1: syntax error
END

# test -I using environment variables
unlink_testfiles();
mkdir("test_dir");

spew("test_dir/test.inc", 'ld a,10');

unlink "test.bin";
z80asm('include "test.inc"', "", 1, "", <<END);
Error at file 'test.asm' line 1: cannot read file 'test.inc'
END

unlink "test.bin";
z80asm('include "test.inc"', "-b -Itest_dir");
check_bin_file("test.bin", pack("C*", 0x3E, 10));

$ENV{TEST_ENV} = 'test';

unlink "test.bin";
z80asm('include "test.inc"', '-b "-I${TEST_ENV}_dir"');
check_bin_file("test.bin", pack("C*", 0x3E, 10));

delete $ENV{TEST_ENV};

unlink "test.bin";
z80asm('include "test.inc"', '-b "-Itest${TEST_ENV}_dir"');
check_bin_file("test.bin", pack("C*", 0x3E, 10));

unlink_testfiles();
done_testing();
