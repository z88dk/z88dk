#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/1572
# z80asm: -reloc-info adds -O directory path twice

use Modern::Perl;
use Test::More;
use Path::Tiny;
require './t/testlib.pl';

path("test1.asm")->spew(<<END);
    public hhll, ll
    defc hhll = 0xff40
    defc ll = 0x40
END
z80asm(<<END, "-mgbz80 -b -l test.asm test1.asm", 0, "", "");
    extern hhll, ll

    ldh a,(0x40)
    ldh a,(0xff40)
    ldh (0x40),a
    ldh (0xff40),a

    ldh a,(ll)
    ldh a,(hhll)
    ldh (ll),a
    ldh (hhll),a
END

z80asm(<<END1, "-mgbz80 -l", 1, "", <<END2);
    ldh a,(0xfe01)
    ldh a,0xff01
END1
Error at file 'test.asm' line 2: syntax error
Warning at file 'test.asm' line 1: integer '65025' out of range
END2

unlink_testfiles();
done_testing();
