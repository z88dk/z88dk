#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2019
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#
# Test https://github.com/z88dk/z88dk/issues/65
# z80asm: separate BSS section not generated from object file if BSS org was -1 at assembly time

use Modern::Perl;
use Test::More;
require './t/testlib.pl';


my $asm = <<'END';
	section CODE
	ret
	section DATA
	org 0x4000	; split file here
	defw 0
	section BSS
	org -1	; split file here
	defw 1
END


# compile and link in one step
unlink_testfiles();
z80asm($asm);
check_bin_file("test.bin", 		pack("C*", 0xC9));
check_bin_file("test_DATA.bin", pack("C*", 0x00, 0x00));
check_bin_file("test_BSS.bin", 	pack("C*", 0x01, 0x00));


# compile and link in two step
unlink_testfiles();
z80asm($asm, "");
run("z80asm -b test.o");
check_bin_file("test.bin", 		pack("C*", 0xC9));
check_bin_file("test_DATA.bin", 	pack("C*", 0x00, 0x00));
check_bin_file("test_BSS.bin", 	pack("C*", 0x01, 0x00));


unlink_testfiles();
done_testing();
