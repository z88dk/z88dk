#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

my $config = slurp("../config.h");
my($version) = $config =~ /Z88DK_VERSION\s*"(.*)"/;
ok $version, "version $version";

capture_ok("z88dk-z80asm -h", <<"END");
Z80 Macro Assembler $version
(c) InterLogic 1993-2009, Paulo Custodio 2011-2023

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

Help Options:
  -h                    Show help options
  -v                    Be verbose

Preprocessor Options:
  -IXIY                 Swap IX and IY registers
  -IXIY-soft            Swap IX and IY registers but write object as unswapped
  -I[=]DIR              Add directory to include search path
  -D[=]SYMBOL[=VALUE]   Define a static symbol in decimal or hex
  -ucase                Convert identifiers to upper case
  -float[=]FORMAT       Set default float format
  -raw-strings          Double-quoted strings may include any character
                        except double quotes

Code Generation Options:
  -m[=]CPU              Assemble for the specified CPU, default z80
  -opt-speed            Optimize for speed
  -debug                Add debug info to map file

Libraries:
  -L[=]DIR              Add directory to library search path
  -x[=]FILE[.lib]       Create a library file.lib
  -l[=]FILE[.lib]       Use library file.lib

Binary Output:
  -O[=]DIR              Output directory
  -o[=]FILE             Output binary file
  -b                    Assemble and link/relocate to file.bin
  -split-bin            Create one binary file per section
  -d                    Assemble only updated files
  -R                    Create relocatable code
  -reloc-info           Generate binary file relocation information
  -r[=]ADDR             Relocate binary file to given address in decimal or hex
  -f[=]BYTE             Default value to fill in DEFS in decimal or hex

Output File Options:
  -s                    Create symbol table file.sym
  -l                    Create listing file.lis
  -m                    Create address map file.map
  -g                    Create global definition file.def

Appmake Options:
  +zx81                 Generate ZX81 .P file, origin at 16514
  +zx                   Generate ZX Spectrum .tap file, origin defaults to
                        23760 (in a REM), but can be set with -rORG >= 24000
                        for above RAMTOP
END

capture_nok("z88dk-z80asm -h=x", <<END);
error: illegal option: -h=x
END

# make sure help fist in 80 columns
ok open(my $fh, "<", __FILE__), "open ".__FILE__;
while (<$fh>) {
    next if /^\s*\#/;
    chomp;
    if (length($_) > 80) {
        ok 0, "line $. longer than 80 chars";
    }
}

unlink_testfiles;
done_testing;
