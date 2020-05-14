#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/1077
# z80asm: optimize for speed - replace JR by JP

use Modern::Perl;
use Test::More;
use Path::Tiny;
require './t/testlib.pl';

unlink_testfiles();

z80asm('djnz 0',	'-b'); 				check_bin_file("test.bin", pack("C*", 0x10, 0xFE));
z80asm('djnz 0',	'-b --opt=speed'); 	check_bin_file("test.bin", pack("C*", 0x10, 0xFE));

z80asm('jr 0',		'-b'); 				check_bin_file("test.bin", pack("C*", 0x18, 0xFE));
z80asm('jr 0',		'-b --opt=speed'); 	check_bin_file("test.bin", pack("C*", 0xC3, 0x00, 0x00));
z80asm('jp 0',		'-b'); 				check_bin_file("test.bin", pack("C*", 0xC3, 0x00, 0x00));
z80asm('jp 0',		'-b --opt=speed'); 	check_bin_file("test.bin", pack("C*", 0xC3, 0x00, 0x00));

z80asm('jr nz, 0',	'-b'); 				check_bin_file("test.bin", pack("C*", 0x20, 0xFE));
z80asm('jr nz, 0',	'-b --opt=speed'); 	check_bin_file("test.bin", pack("C*", 0xC2, 0x00, 0x00));
z80asm('jp nz, 0',	'-b'); 				check_bin_file("test.bin", pack("C*", 0xC2, 0x00, 0x00));
z80asm('jp nz, 0',	'-b --opt=speed'); 	check_bin_file("test.bin", pack("C*", 0xC2, 0x00, 0x00));

z80asm('jr z, 0',	'-b'); 				check_bin_file("test.bin", pack("C*", 0x28, 0xFE));
z80asm('jr z, 0',	'-b --opt=speed'); 	check_bin_file("test.bin", pack("C*", 0xCA, 0x00, 0x00));
z80asm('jp z, 0',	'-b'); 				check_bin_file("test.bin", pack("C*", 0xCA, 0x00, 0x00));
z80asm('jp z, 0',	'-b --opt=speed'); 	check_bin_file("test.bin", pack("C*", 0xCA, 0x00, 0x00));

z80asm('jr nc, 0',	'-b'); 				check_bin_file("test.bin", pack("C*", 0x30, 0xFE));
z80asm('jr nc, 0',	'-b --opt=speed'); 	check_bin_file("test.bin", pack("C*", 0xD2, 0x00, 0x00));
z80asm('jp nc, 0',	'-b'); 				check_bin_file("test.bin", pack("C*", 0xD2, 0x00, 0x00));
z80asm('jp nc, 0',	'-b --opt=speed'); 	check_bin_file("test.bin", pack("C*", 0xD2, 0x00, 0x00));

z80asm('jr c, 0',	'-b'); 				check_bin_file("test.bin", pack("C*", 0x38, 0xFE));
z80asm('jr c, 0',	'-b --opt=speed'); 	check_bin_file("test.bin", pack("C*", 0xDA, 0x00, 0x00));
z80asm('jp c, 0',	'-b'); 				check_bin_file("test.bin", pack("C*", 0xDA, 0x00, 0x00));
z80asm('jp c, 0',	'-b --opt=speed'); 	check_bin_file("test.bin", pack("C*", 0xDA, 0x00, 0x00));

unlink_testfiles();
done_testing();
