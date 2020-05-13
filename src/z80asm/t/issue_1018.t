#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/1018
# z80asm: support for variant equ syntax

use Modern::Perl;
use Test::More;
use Path::Tiny;
require './t/testlib.pl';

unlink_testfiles();

z80asm(<<'END');
#define set equ
one = 		1
 two = 		2
 .three = 	3
 four: = 	4
five equ 	5
 six equ 	6
 .seven equ 7
 eight: equ 8
defb one,two,three,four,five,six,seven,eight
END
check_bin_file("test.bin", pack("C*", 1..8));

z80asm(<<'END', "", 1, "", <<'ERR');
.e: equ 1
END
Error at file 'test.asm' line 1: syntax error
ERR

unlink_testfiles();
done_testing();
