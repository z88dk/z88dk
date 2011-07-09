#!/usr/bin/perl

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/z80ops.t,v 1.2 2011-07-09 17:36:09 pauloscustodio Exp $
# $Log: z80ops.t,v $
# Revision 1.2  2011-07-09 17:36:09  pauloscustodio
# Copied cvs log into $Log$ history
#
# Revision 1.1  2011/07/09 01:02:45  pauloscustodio
# Started to build test suite in t/ *.t unsing Perl prove. Included test for all standard
# Z80 opcodes; need to be extended with directives and opcodes for Z80 variants.
#

use strict;
use warnings;
use File::Slurp;
use Test::More;
require 't/test_utils.pl';

my $ASM = read_file("t/data/z80ops.asm");
my $BIN = read_file("t/data/z80ops.bin", binmode => ':raw');

# Assemble z80ops.asm, compare to z80ops.bin
t_z80asm_ok(0, $ASM, $BIN);

unlink_testfiles();
done_testing();
