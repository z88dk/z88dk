#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Test https://github.com/z88dk/z88dk/issues/65

use Modern::Perl;
use Capture::Tiny::Extended 'capture';
use t::TestZ80asm;
use t::Listfile;

my($out, $err, $exit);

unlink "test.o", "test.bin", "test_CODE.bin", "test_DATA.bin", "test_BSS.bin";
write_file("test.asm", <<'END');
	section CODE
	ret
	section DATA
	org 0x4000	; split file here
	defw 0
	section BSS
	org -1	; split file here
	defw 1
END
($out, $err, $exit) = capture { system "./z80asm -b test.asm"; };
is $out, "";
is $err, "";
is $exit, 0;
test_binfile("test.bin", 		pack("C*", 0xC9));
test_binfile("test_DATA.bin", 	pack("C*", 0x00, 0x00));
test_binfile("test_BSS.bin", 	pack("C*", 0x01, 0x00));

unlink "test.o", "test.bin", "test_CODE.bin", "test_DATA.bin", "test_BSS.bin";
($out, $err, $exit) = capture { system "./z80asm test.asm"; };
is $out, "";
is $err, "";
is $exit, 0;
($out, $err, $exit) = capture { system "./z80asm -b test.o"; };
is $out, "";
is $err, "";
is $exit, 0;
test_binfile("test.bin", 		pack("C*", 0xC9));
test_binfile("test_DATA.bin", 	pack("C*", 0x00, 0x00));
test_binfile("test_BSS.bin", 	pack("C*", 0x01, 0x00));

