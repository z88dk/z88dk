#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2018
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test macros

use strict;
use warnings;
use v5.10;
use Test::More;
require './t/testlib.pl';

unlink_testfiles();

z80asm(<<'END');
	nop
END
check_bin_file("test.bin", pack("C*", 0));


z80asm(<<'END');
#define nil 0
#undef  nil
#undef  nil			; ignored
#define nil nop		; define macro
	nil
END
check_bin_file("test.bin", pack("C*", 0));

z80asm(<<'END');
#define label here
.label jp here
END
check_bin_file("test.bin", pack("C*", 0xC3, 0, 0));

z80asm(<<'END', "", 1, "", <<'ERR');
#define nil nop
#define nil nop
	nil
END
Error at file 'test.asm' line 2: macro 'nil' redefined
1 errors occurred during assembly
ERR

unlink_testfiles();
done_testing();
