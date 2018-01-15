#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/563
# z80asm: consolidated object file erroneously eliminates globally exported defc

use strict;
use warnings;
use v5.10;

use Test::More;

require './t/testlib.pl';

spew("test1.asm",<<END);
		global main1
		extern main

		defc main1 = main
END

spew("test2.asm",<<END);
		global main
	main:
		ret
END

run("z80asm -otestx.o test1.asm test2.asm");
z80nm("testx.o", <<'END');

File testx.o at $0000: Z80RMF11
  Name: testx
  Names:
    G = $0000 main1 test1.asm:4
    G A $0000 main test2.asm:2
  Expressions:
    E =  (test1.asm:4) $0000 $0000: main1 := main
  Code: 1 bytes
    C $0000: C9
END

spew("test.asm", <<'END');
		extern main1
		call main1
END

run("z80asm -b test.asm testx.o");
check_bin_file("test.bin", pack("C*", 0xCD, 0x03, 0x00, 0xC9));

unlink_testfiles();
done_testing();
