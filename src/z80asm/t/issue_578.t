#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2019
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/578
# z80asm: BINARY directive cannot follow label on same line

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

spew("test1.inc",<<END);
		nop
END

spew("test1.bin", "\x01");

z80asm(<<END, "-b -m");
lbl1:	include "test1.inc"
lbl2:	binary  "test1.bin"
END

check_bin_file("test.bin", pack("C*", 0, 1));
z80nm("test.o", <<'END');
Object  file test.o at $0000: Z80RMF12
  Name: test
  Section "": 2 bytes
    C $0000: 00 01
  Symbols:
    L A $0000 lbl1 (section "") (file test.asm:1)
    L A $0001 lbl2 (section "") (file test.asm:2)
END

unlink_testfiles();
done_testing();
