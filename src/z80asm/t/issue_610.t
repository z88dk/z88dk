#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/610
# z80asm: z80asm removes .bin (and other) files when assembling files

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

unlink_testfiles();
spew("test.asm", 	"nop");
spew("test.o", 		"dummy");
spew("test.err",	"dummy");
spew("test.lis",	"test");
spew("test.bin",	"test");
spew("test.sym",	"test");
spew("test.map",	"test");
spew("test.reloc",	"test");
spew("test.def",	"test");

run("./z88dk-z80asm test");

z80nm("test.o", <<'END');
Object  file test.o at $0000: Z80RMF16
  Name: test
  Section "": 1 bytes
    C $0000: 00
END

ok ! -f "test.err";

check_text_file("test.lis",		"test");
check_text_file("test.bin",		"test");
check_text_file("test.sym",		"test");
check_text_file("test.map",		"test");
check_text_file("test.reloc",	"test");
check_text_file("test.def",		"test");

unlink_testfiles();
done_testing();
