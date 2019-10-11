#!/usr/bin/perl

# Z88DK Z80 Module Assembler
#
# Copyright (C) Paulo Custodio, 2011-2019
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/17
# z80asm: bug with filenames interpreting escape sequences

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

for my $slash ('/', '\\') {
	next if $^O ne 'MSWin32' && $slash ne '/';
	
	ok 1, "test with slash = $slash";
	
	unlink_testfiles();
	mkdir("test_dir");
	spew("test_dir/test.inc", <<END);
		defb 1
END
	spew("test_dir/test1.bin", pack("C*", 2));
	spew("test.asm", <<END);
		include "test_dir${slash}test.inc"
		binary  "test_dir${slash}test1.bin"
		defb 3
END

	run("z80asm -b test.asm");
	check_bin_file("test.bin", pack("C*", 1, 2, 3));
	
	spew("test.asm", <<END);
		line 1, "test_dir${slash}test.inc"
		ld
END
	run("z80asm test.asm", 1, "", <<END);
Error at file 'test_dir${slash}test.inc' line 1: syntax error
END

	spew("test.asm", <<END);
		c_line 1, "test_dir${slash}test.c"
		ld
END
	run("z80asm test.asm", 1, "", <<END);
Error at file 'test_dir${slash}test.c' line 1: syntax error
END

}

unlink_testfiles();
done_testing();
