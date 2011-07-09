#!/usr/bin/perl

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0005.t,v 1.2 2011-07-09 17:36:09 pauloscustodio Exp $
# $Log: BUG_0005.t,v $
# Revision 1.2  2011-07-09 17:36:09  pauloscustodio
# Copied cvs log into $Log$ history
#
# Revision 1.1  2011/07/09 01:02:45  pauloscustodio
# Started to build test suite in t/ *.t unsing Perl prove. Included test for all standard
# Z80 opcodes; need to be extended with directives and opcodes for Z80 variants.
#
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
