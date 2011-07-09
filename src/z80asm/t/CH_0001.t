#!/usr/bin/perl

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/CH_0001.t,v 1.2 2011-07-09 17:36:09 pauloscustodio Exp $
# $Log: CH_0001.t,v $
# Revision 1.2  2011-07-09 17:36:09  pauloscustodio
# Copied cvs log into $Log$ history
#
# Revision 1.1  2011/07/09 01:02:45  pauloscustodio
# Started to build test suite in t/ *.t unsing Perl prove. Included test for all standard
# Z80 opcodes; need to be extended with directives and opcodes for Z80 variants.
#
# Test correction of CH_0001, see hist.c for description

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

t_z80asm_error("ld", "File 'test.asm', at line 1, Syntax error");

unlink_testfiles();
done_testing();
