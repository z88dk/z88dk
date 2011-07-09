#!perl

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0005.t,v 1.1 2011-07-09 01:02:45 pauloscustodio Exp $
# Test correction of BUG_0005, see hist.c for description

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

# OK:    (ix), (ix+3), (ix-3)
# ERROR: (ix 4)
t_z80asm_ok(0, "inc (ix)",      "\xDD\x34\x00");
t_z80asm_ok(0, "inc (ix + 3)",  "\xDD\x34\x03");
t_z80asm_ok(0, "inc (ix - 3)",  "\xDD\x34\xFD");
t_z80asm_error("inc (ix   3)", "File 'test.asm', at line 1, Syntax error");

unlink_testfiles();
done_testing();
