#!perl

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/CH_0002.t,v 1.1 2011-07-09 01:02:45 pauloscustodio Exp $
# Test correction of CH_0002, see hist.c for description

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

t_z80asm_ok(0, "ld a,    3)",   "\x3E\x03");
t_z80asm_ok(0, "ld a,+ + 3)",   "\x3E\x03");
t_z80asm_ok(0, "ld a,+ - 3)",   "\x3E\xFD");

t_z80asm_ok(0, "ld a,-   3)",   "\x3E\xFD");
t_z80asm_ok(0, "ld a,- + 3)",   "\x3E\xFD");
t_z80asm_ok(0, "ld a,- - 3)",   "\x3E\x03");

t_z80asm_ok(0, "inc (ix -  3)", "\xDD\x34\xFD");
t_z80asm_ok(0, "inc (ix - -3)", "\xDD\x34\x03");
t_z80asm_ok(0, "inc (ix - +3)", "\xDD\x34\xFD");

t_z80asm_ok(0, "inc (ix + 3)",  "\xDD\x34\x03");
t_z80asm_ok(0, "inc (ix + -3)", "\xDD\x34\xFD");
t_z80asm_ok(0, "inc (ix + +3)", "\xDD\x34\x03");

unlink_testfiles();
done_testing();
