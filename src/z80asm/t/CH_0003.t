#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Test CH_0003, see hist.c

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

t_z80asm_error("ld", "Error at file 'test.asm' line 1: syntax error");

unlink_testfiles();
done_testing();
