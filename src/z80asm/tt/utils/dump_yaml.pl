#!perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Dump contents of YAML file

use Modern::Perl;
use YAML;
use Data::Dump 'dump';
use Path::Tiny;

my $file = shift or die;
print dump(Load(path($file)->slurp));
