#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Test correction of CH_0002, see hist.c for description

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

t_z80asm_ok(0, "ld a,    3",   "\x3E\x03");
t_z80asm_ok(0, "ld a,+ + 3",   "\x3E\x03");
t_z80asm_ok(0, "ld a,+ - 3",   "\x3E\xFD");

t_z80asm_ok(0, "ld a,-   3",   "\x3E\xFD");
t_z80asm_ok(0, "ld a,- + 3",   "\x3E\xFD");
t_z80asm_ok(0, "ld a,- - 3",   "\x3E\x03");

t_z80asm_ok(0, "inc (ix -  3)", "\xDD\x34\xFD");
t_z80asm_ok(0, "inc (ix - -3)", "\xDD\x34\x03");
t_z80asm_ok(0, "inc (ix - +3)", "\xDD\x34\xFD");

t_z80asm_ok(0, "inc (ix + 3)",  "\xDD\x34\x03");
t_z80asm_ok(0, "inc (ix + -3)", "\xDD\x34\xFD");
t_z80asm_ok(0, "inc (ix + +3)", "\xDD\x34\x03");

unlink_testfiles();
done_testing();
