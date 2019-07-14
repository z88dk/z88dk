#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2018
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test -h

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

my $config = slurp("../config.h");
my($version) = $config =~ /Z88DK_VERSION\s*"(.*)"/;
ok $version, "version $version";

for my $opt (qw( -h --help )) {
	run("z80asm $opt", 0, <<"END", "");
Z80 Module Assembler $version
(c) InterLogic 1993-2009, Paulo Custodio 2011-2018

Usage:
  z80asm [options] { \@<modulefile> | <filename> }

  [] = optional, {} = may be repeated, | = OR clause.

  To assemble 'fred.asm' use 'fred' or 'fred.asm'

  <modulefile> contains list of file names of all modules to be linked,
  one module per line.

  File types recognized or created by z80asm:
    .asm   = source file
    .o     = object file
    .lis   = list file
    .bin   = Z80 binary file
    .sym   = symbols file
    .map   = map file
    .reloc = reloc file
    .def   = global address definition file
    .err   = error file

Help Options:
  -h, --help             Show help options
  -v, --verbose          Be verbose

Code Generation Options:
  --cpu=z80n             Assemble for the Z80 variant of ZX Next
  --cpu=z80              Assemble for the Z80
  --cpu=z180             Assemble for the Z180
  --cpu=r2k              Assemble for the Rabbit 2000
  --cpu=r3k              Assemble for the Rabbit 3000
  --cpu=ti83plus         Assemble for the TI83Plus
  --cpu=ti83             Assemble for the TI83
  --IXIY                 Swap IX and IY registers
  --opt=speed            Optimize for speed
  --debug                Add debug info to map file

Environment:
  -I, --inc-path=PATH    Add directory to include search path
  -L, --lib-path=PATH    Add directory to library search path
  -D, --define=SYMBOL    Define a static symbol

Libraries:
  -x, --make-lib=FILE    Create a library file.lib
  -i, --use-lib=FILE     Use library file.lib

Binary Output:
  -O, --out-dir=DIR      Output directory
  -o, --output=FILE      Output binary file
  -b, --make-bin         Assemble and link/relocate to file.bin
  --split-bin            Create one binary file per section
  -d, --update           Assemble only updated files
  -r, --origin=ADDR      Relocate binary file to given address (decimal or hex)
  -R, --relocatable      Create relocatable code
  --reloc-info           Geneate binary file relocation information
  --filler=BYTE          Default value to fill in DEFS (decimal or hex)

Output File Options:
  -s, --symtable         Create symbol table file.sym
  -l, --list             Create listing file.lis
  -m, --map              Create address map file.map
  -g, --globaldef        Create global definition file.def

Appmake Options:
  +zx81                  Generate ZX81 .P file, origin at 16514
  +zx                    Generate ZX Spectrum .tap file, origin defaults to
                         23760 (in a REM), but can be set with -rORG >= 24000
                         for above RAMTOP
END

	run("z80asm $opt=x", 1, "", <<END);
Error: illegal option: $opt=x
END
}

# make sure help fist in 80 columns
ok open(my $fh, "<", __FILE__), "open ".__FILE__;
while (<$fh>) {
	next if /^\s*\#/;
	chomp;
	if (length($_) > 80) {
		ok 0, "line $. longer than 80 chars";
	}
}

unlink_testfiles();
done_testing();
