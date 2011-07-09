#!perl

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/BUG_0001.t,v 1.1 2011-07-09 01:02:45 pauloscustodio Exp $
# Test correction of BUG_0001, see hist.c for description

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

my $ASM = "
JP NN
JP NN
NN:
";
my $BIN = "\xC3\x06\x00\xC3\x06\x00";

# Assemble z80ops.asm, compare to z80ops.bin
t_z80asm_ok(0, $ASM, $BIN, "-t4 -b");

unlink_testfiles();
done_testing();
