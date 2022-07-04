#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

my $config = slurp("../config.h");
my($version) = $config =~ /Z88DK_VERSION\s*"(.*)"/;
ok $version, "version $version";

capture_ok("z88dk-z80asm -h", <<"END");
Z80 Macro Assembler $version
(c) InterLogic 1993-2009, Paulo Custodio 2011-2022

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
  -h                     Show help options
  -v                     Be verbose

Preprocessor Options:
  -IXIY                  Swap IX and IY registers
  -IPATH                 Add directory to include search path
  -DSYMBOL[=VALUE]       Define a static symbol
  -ucase                 Convert identifiers to upper case
  -float=FORMAT          Set default float format

Code Generation Options:
  -mz80n                 Assemble for the Z80 variant of ZX Next
  -mz80                  Assemble for the Z80
  -mgbz80                Assemble for the GameBoy Z80
  -m8080                 Assemble for the 8080 (with Zilog or Intel mnemonics)
  -m8085                 Assemble for the 8085 (with Zilog or Intel mnemonics)
  -mz180                 Assemble for the Z180
  -mr2ka                 Assemble for the Rabbit 2000A
  -mr3k                  Assemble for the Rabbit 3000
  -mti83plus             Assemble for the TI83Plus
  -mti83                 Assemble for the TI83
  -opt-speed             Optimize for speed
  -debug                 Add debug info to map file

Libraries:
  -LPATH                 Add directory to library search path
  -xFILE                 Create a library file.lib
  -lFILE                 Use library file.lib

Binary Output:
  -ODIR                  Output directory
  -oFILE                 Output binary file
  -b                     Assemble and link/relocate to file.bin
  -split-bin             Create one binary file per section
  -d                     Assemble only updated files
  -rADDR                 Relocate binary file to given address (decimal or hex)
  -R                     Create relocatable code
  -reloc-info            Generate binary file relocation information
  -fBYTE                 Default value to fill in DEFS (decimal or hex)

Output File Options:
  -s                     Create symbol table file.sym
  -l                     Create listing file.lis
  -m                     Create address map file.map
  -g                     Create global definition file.def

Appmake Options:
  +zx81                  Generate ZX81 .P file, origin at 16514
  +zx                    Generate ZX Spectrum .tap file, origin defaults to
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
