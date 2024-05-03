//-----------------------------------------------------------------------------
// z80asm - command line options
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "../../config.h"       // Z88DK_VERSION
#include "options.h"
#include "t/test.h"
using namespace std;

void test_exit_copyright() {
    RUN_OK("exec_exit_copyright");
    OUT_IS("Z80 Macro Assembler " Z88DK_VERSION "\n"
        "(c) InterLogic 1993-2009, Paulo Custodio 2011-2024\n");
    ERR_IS("");
}

int exec_exit_copyright() {
    Options opts;
    opts.exit_copyright();
    return EXIT_FAILURE;    // not reached
}

void test_exit_help() {
    RUN_OK("exec_exit_help");
    OUT_IS(
        "Z80 Macro Assembler " Z88DK_VERSION "\n"
        "(c) InterLogic 1993-2009, Paulo Custodio 2011-2024\n"
        "\n"
        "Usage:\n"
        "  z80asm [options] { @<modulefile> | <filename> }\n"
        "\n"
        "  [] = optional, {} = may be repeated, | = OR clause.\n"
        "\n"
        "  To assemble 'fred.asm' use 'fred' or 'fred.asm'\n"
        "\n"
        "  <modulefile> contains list of file names of all modules to be linked,\n"
        "  one module per line.\n"
        "\n"
        "  File types recognized or created by z80asm:\n"
        "    .asm   = source file\n"
        "    .o     = object file\n"
        "    .lis   = list file\n"
        "    .bin   = Z80 binary file\n"
        "    .sym   = symbols file\n"
        "    .map   = map file\n"
        "    .reloc = reloc file\n"
        "    .def   = global address definition file\n"
        "\n"
        "Help Options:\n"
        "  -h                    Show help options\n"
        "  -v                    Be verbose\n"
        "\n"
        "Preprocessor Options:\n"
        "  -IXIY                 Swap IX and IY registers\n"
        "  -IXIY-soft            Swap IX and IY registers but write object as unswapped\n"
        "  -I[=]DIR              Add directory to include search path\n"
        "  -D[=]SYMBOL[=VALUE]   Define a static symbol in decimal or hex\n"
        "  -ucase                Convert identifiers to upper case\n"
        "  -float[=]FORMAT       Set default float format, one of:\n"
        "                        genmath, math48, ieee16, ieee32, ieee64,\n"
        "                        z80, zx81, zx, z88, mbfs, mbf40, mbf64, am9511\n"
        "  -raw-strings          Double-quoted strings may include any character\n"
        "                        except double quotes\n"
        "  -m4[=]OPTIONS         Pass options to the m4 subprocess\n"
        "\n"
        "Code Generation Options:\n"
        "  -m[=]CPU              Assemble for the specified CPU, default z80, one of:\n"
        "                        *, z80, z80_strict, z180, ez80_z80, ez80, z80n, gbz80,\n"
        "                        r2ka, r3k, r4k, r5k, 8080, 8085, r800, kc160, kc160_z80,\n"
        "                        ti83, ti83plus\n"
        "  -opt-speed            Optimize for speed\n"
        "  -debug                Add debug info to map file\n"
        "\n"
        "Libraries:\n"
        "  -L[=]DIR              Add directory to library search path\n"
        "  -x[=]FILE[.lib]       Create a library file.lib\n"
        "  -l[=]FILE[.lib]       Use library file.lib\n"
        "\n"
        "Binary Output:\n"
        "  -O[=]DIR              Output directory\n"
        "  -o[=]FILE             Output binary file\n"
        "  -b                    Assemble and link/relocate to file.bin\n"
        "  -split-bin            Create one binary file per section\n"
        "  -d                    Assemble only updated files\n"
        "  -R                    Create relocatable code\n"
        "  -reloc-info           Generate binary file relocation information\n"
        "  -r[=]ADDR             Relocate binary file to given address in decimal or hex\n"
        "  -f[=]BYTE             Default value to fill in DEFS in decimal or hex\n"
        "\n"
        "Output File Options:\n"
        "  -s                    Create symbol table file.sym\n"
        "  -l                    Create listing file.lis\n"
        "  -m                    Create address map file.map\n"
        "  -g                    Create global definition file.def\n"
        "\n"
        "Appmake Options:\n"
        "  +zx81                 Generate ZX81 .P file, origin at 16514\n"
        "  +zx                   Generate ZX Spectrum .tap file, origin defaults to\n"
        "                        23760 (in a REM), but can be set with -rORG >= 24000\n"
        "                        for above RAMTOP\n"
    );
    ERR_IS("");
}

int exec_exit_help() {
    Options opts;
    opts.exit_help();
    return EXIT_FAILURE;    // not reached
}
