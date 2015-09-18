#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2015
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# CH_0017 : Align with spaces, deprecate -t option

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';

# Integer out of range
ok 1, "Tested by option-m.t option-g.t option-t.t";

unlink_testfiles();
done_testing();
