//-----------------------------------------------------------------------------
// z80asm - command line options
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "../../config.h"       // Z88DK_VERSION
#include "common.h"
#include "options.h"
#include "utils.h"
#include "t/test.h"
#include "xassert.h"
using namespace std;

#if __has_include(<filesystem>)
// std::filesystem from C++17
#include <filesystem>
namespace fs = std::filesystem;
#else
// boost::filesystem from Boost
#include <boost/filesystem.hpp>
namespace fs = boost::filesystem;
#endif

#define T_FLAG(name, option)                \
            do {                            \
                Options opts;               \
                NOK(opts.name());           \
                opts.parse_option(option);  \
                OK(opts.name());            \
            } while (0)

void test_option_flags() {
    T_FLAG(opt_speed, "-opt-speed");
    T_FLAG(debug, "-debug");
    T_FLAG(debug_z80asm, "-vv");
    T_FLAG(make_bin, "-b");
    T_FLAG(split_bin, "-split-bin");
    T_FLAG(date_stamp, "-d");
    T_FLAG(relocatable, "-R");
    T_FLAG(reloc_info, "-reloc-info");
    T_FLAG(symtable, "-s");
    T_FLAG(list_file, "-l");
    T_FLAG(map_file, "-m");
    T_FLAG(global_def, "-g");
}

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
        "  -raw-strings          Double-quoted strings may include any character\n"
        "                        except double quotes\n"
        "  -m4[=]OPTIONS         Pass options to the m4 subprocess\n"
        "\n"
        "Code Generation Options:\n"
        "  -m[=]CPU              Assemble for the specified CPU, default z80, one of:\n"
        "                        *, z80, z80_strict, z180, ez80_z80, ez80, z80n, gbz80,\n"
        "                        r2ka, r3k, r4k, r5k, 8080, 8085, r800, kc160, kc160_z80,\n"
        "                        ti83, ti83plus\n"
        "  -float[=]FORMAT       Set default float format, one of:\n"
        "                        genmath, math48, ieee16, ieee32, ieee64,\n"
        "                        z80, zx81, zx, z88, mbfs, mbf40, mbf64, am9511\n"
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

void test_option_cpu1() {
    RUN_NOK("exec_option_cpu1_invalid");
    OUT_IS("");
    ERR_IS(
        "error: illegal -m option: xpto\n"
        "error: list of available CPUs: 8080,8085,ez80,ez80_z80,gbz80,kc160,kc160_z80,"
        "r2ka,r3k,r4k,r5k,r800,z180,z80,z80_strict,z80n\n");
}

int exec_option_cpu1_invalid() {
    Options opts;
    opts.set_cpu("xpto");
    return g_asm.exit_code();
}

void test_option_cpu2() {
    Options opts;

    opts.set_cpu("*");
    IS(opts.cpu(), CPU_Z80);
    OK(opts.lib_for_all_cpus());
    IS(opts.symbol_value("__CPU_Z80__"), 1);
    IS(opts.symbol_value("__CPU_Z80_STRICT__"), 0);
    IS(opts.symbol_value("__CPU_Z80N__"), 0);
    IS(opts.symbol_value("__CPU_Z180__"), 0);
    IS(opts.symbol_value("__CPU_EZ80__"), 0);
    IS(opts.symbol_value("__CPU_EZ80_Z80__"), 0);
    IS(opts.symbol_value("__CPU_ZILOG__"), 1);
    IS(opts.symbol_value("__CPU_R800__"), 0);
    IS(opts.symbol_value("__CPU_R2KA__"), 0);
    IS(opts.symbol_value("__CPU_R3K__"), 0);
    IS(opts.symbol_value("__CPU_R4K__"), 0);
    IS(opts.symbol_value("__CPU_R5K__"), 0);
    IS(opts.symbol_value("__CPU_RABBIT__"), 0);
    IS(opts.symbol_value("__CPU_8080__"), 0);
    IS(opts.symbol_value("__CPU_8085__"), 0);
    IS(opts.symbol_value("__CPU_INTEL__"), 0);
    IS(opts.symbol_value("__CPU_GBZ80__"), 0);
    IS(opts.symbol_value("__CPU_KC160__"), 0);
    IS(opts.symbol_value("__CPU_KC160_Z80__"), 0);
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.set_cpu("z80");
    IS(opts.cpu(), CPU_Z80);
    NOK(opts.lib_for_all_cpus());
    IS(opts.symbol_value("__CPU_Z80__"), 1);
    IS(opts.symbol_value("__CPU_Z80_STRICT__"), 0);
    IS(opts.symbol_value("__CPU_Z80N__"), 0);
    IS(opts.symbol_value("__CPU_Z180__"), 0);
    IS(opts.symbol_value("__CPU_EZ80__"), 0);
    IS(opts.symbol_value("__CPU_EZ80_Z80__"), 0);
    IS(opts.symbol_value("__CPU_ZILOG__"), 1);
    IS(opts.symbol_value("__CPU_R800__"), 0);
    IS(opts.symbol_value("__CPU_R2KA__"), 0);
    IS(opts.symbol_value("__CPU_R3K__"), 0);
    IS(opts.symbol_value("__CPU_R4K__"), 0);
    IS(opts.symbol_value("__CPU_R5K__"), 0);
    IS(opts.symbol_value("__CPU_RABBIT__"), 0);
    IS(opts.symbol_value("__CPU_8080__"), 0);
    IS(opts.symbol_value("__CPU_8085__"), 0);
    IS(opts.symbol_value("__CPU_INTEL__"), 0);
    IS(opts.symbol_value("__CPU_GBZ80__"), 0);
    IS(opts.symbol_value("__CPU_KC160__"), 0);
    IS(opts.symbol_value("__CPU_KC160_Z80__"), 0);
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.set_cpu("z80_strict");
    IS(opts.cpu(), CPU_Z80_STRICT);
    NOK(opts.lib_for_all_cpus());
    IS(opts.symbol_value("__CPU_Z80__"), 0);
    IS(opts.symbol_value("__CPU_Z80_STRICT__"), 1);
    IS(opts.symbol_value("__CPU_Z80N__"), 0);
    IS(opts.symbol_value("__CPU_Z180__"), 0);
    IS(opts.symbol_value("__CPU_EZ80__"), 0);
    IS(opts.symbol_value("__CPU_EZ80_Z80__"), 0);
    IS(opts.symbol_value("__CPU_ZILOG__"), 1);
    IS(opts.symbol_value("__CPU_R800__"), 0);
    IS(opts.symbol_value("__CPU_R2KA__"), 0);
    IS(opts.symbol_value("__CPU_R3K__"), 0);
    IS(opts.symbol_value("__CPU_R4K__"), 0);
    IS(opts.symbol_value("__CPU_R5K__"), 0);
    IS(opts.symbol_value("__CPU_RABBIT__"), 0);
    IS(opts.symbol_value("__CPU_8080__"), 0);
    IS(opts.symbol_value("__CPU_8085__"), 0);
    IS(opts.symbol_value("__CPU_INTEL__"), 0);
    IS(opts.symbol_value("__CPU_GBZ80__"), 0);
    IS(opts.symbol_value("__CPU_KC160__"), 0);
    IS(opts.symbol_value("__CPU_KC160_Z80__"), 0);
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.set_cpu("z180");
    IS(opts.cpu(), CPU_Z180);
    NOK(opts.lib_for_all_cpus());
    IS(opts.symbol_value("__CPU_Z80__"), 0);
    IS(opts.symbol_value("__CPU_Z80_STRICT__"), 0);
    IS(opts.symbol_value("__CPU_Z80N__"), 0);
    IS(opts.symbol_value("__CPU_Z180__"), 1);
    IS(opts.symbol_value("__CPU_EZ80__"), 0);
    IS(opts.symbol_value("__CPU_EZ80_Z80__"), 0);
    IS(opts.symbol_value("__CPU_ZILOG__"), 1);
    IS(opts.symbol_value("__CPU_R800__"), 0);
    IS(opts.symbol_value("__CPU_R2KA__"), 0);
    IS(opts.symbol_value("__CPU_R3K__"), 0);
    IS(opts.symbol_value("__CPU_R4K__"), 0);
    IS(opts.symbol_value("__CPU_R5K__"), 0);
    IS(opts.symbol_value("__CPU_RABBIT__"), 0);
    IS(opts.symbol_value("__CPU_8080__"), 0);
    IS(opts.symbol_value("__CPU_8085__"), 0);
    IS(opts.symbol_value("__CPU_INTEL__"), 0);
    IS(opts.symbol_value("__CPU_GBZ80__"), 0);
    IS(opts.symbol_value("__CPU_KC160__"), 0);
    IS(opts.symbol_value("__CPU_KC160_Z80__"), 0);
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.set_cpu("ez80_z80");
    IS(opts.cpu(), CPU_EZ80_Z80);
    NOK(opts.lib_for_all_cpus());
    IS(opts.symbol_value("__CPU_Z80__"), 0);
    IS(opts.symbol_value("__CPU_Z80_STRICT__"), 0);
    IS(opts.symbol_value("__CPU_Z80N__"), 0);
    IS(opts.symbol_value("__CPU_Z180__"), 0);
    IS(opts.symbol_value("__CPU_EZ80__"), 0);
    IS(opts.symbol_value("__CPU_EZ80_Z80__"), 1);
    IS(opts.symbol_value("__CPU_ZILOG__"), 1);
    IS(opts.symbol_value("__CPU_R800__"), 0);
    IS(opts.symbol_value("__CPU_R2KA__"), 0);
    IS(opts.symbol_value("__CPU_R3K__"), 0);
    IS(opts.symbol_value("__CPU_R4K__"), 0);
    IS(opts.symbol_value("__CPU_R5K__"), 0);
    IS(opts.symbol_value("__CPU_RABBIT__"), 0);
    IS(opts.symbol_value("__CPU_8080__"), 0);
    IS(opts.symbol_value("__CPU_8085__"), 0);
    IS(opts.symbol_value("__CPU_INTEL__"), 0);
    IS(opts.symbol_value("__CPU_GBZ80__"), 0);
    IS(opts.symbol_value("__CPU_KC160__"), 0);
    IS(opts.symbol_value("__CPU_KC160_Z80__"), 0);
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.set_cpu("ez80");
    IS(opts.cpu(), CPU_EZ80);
    NOK(opts.lib_for_all_cpus());
    IS(opts.symbol_value("__CPU_Z80__"), 0);
    IS(opts.symbol_value("__CPU_Z80_STRICT__"), 0);
    IS(opts.symbol_value("__CPU_Z80N__"), 0);
    IS(opts.symbol_value("__CPU_Z180__"), 0);
    IS(opts.symbol_value("__CPU_EZ80__"), 1);
    IS(opts.symbol_value("__CPU_EZ80_Z80__"), 0);
    IS(opts.symbol_value("__CPU_ZILOG__"), 1);
    IS(opts.symbol_value("__CPU_R800__"), 0);
    IS(opts.symbol_value("__CPU_R2KA__"), 0);
    IS(opts.symbol_value("__CPU_R3K__"), 0);
    IS(opts.symbol_value("__CPU_R4K__"), 0);
    IS(opts.symbol_value("__CPU_R5K__"), 0);
    IS(opts.symbol_value("__CPU_RABBIT__"), 0);
    IS(opts.symbol_value("__CPU_8080__"), 0);
    IS(opts.symbol_value("__CPU_8085__"), 0);
    IS(opts.symbol_value("__CPU_INTEL__"), 0);
    IS(opts.symbol_value("__CPU_GBZ80__"), 0);
    IS(opts.symbol_value("__CPU_KC160__"), 0);
    IS(opts.symbol_value("__CPU_KC160_Z80__"), 0);
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.set_cpu("z80n");
    IS(opts.cpu(), CPU_Z80N);
    NOK(opts.lib_for_all_cpus());
    IS(opts.symbol_value("__CPU_Z80__"), 0);
    IS(opts.symbol_value("__CPU_Z80_STRICT__"), 0);
    IS(opts.symbol_value("__CPU_Z80N__"), 1);
    IS(opts.symbol_value("__CPU_Z180__"), 0);
    IS(opts.symbol_value("__CPU_EZ80__"), 0);
    IS(opts.symbol_value("__CPU_EZ80_Z80__"), 0);
    IS(opts.symbol_value("__CPU_ZILOG__"), 1);
    IS(opts.symbol_value("__CPU_R800__"), 0);
    IS(opts.symbol_value("__CPU_R2KA__"), 0);
    IS(opts.symbol_value("__CPU_R3K__"), 0);
    IS(opts.symbol_value("__CPU_R4K__"), 0);
    IS(opts.symbol_value("__CPU_R5K__"), 0);
    IS(opts.symbol_value("__CPU_RABBIT__"), 0);
    IS(opts.symbol_value("__CPU_8080__"), 0);
    IS(opts.symbol_value("__CPU_8085__"), 0);
    IS(opts.symbol_value("__CPU_INTEL__"), 0);
    IS(opts.symbol_value("__CPU_GBZ80__"), 0);
    IS(opts.symbol_value("__CPU_KC160__"), 0);
    IS(opts.symbol_value("__CPU_KC160_Z80__"), 0);
    NOK(opts.ti83());
    NOK(opts.ti83plus());
}

void test_option_cpu3() {
    Options opts;

    opts.set_cpu("gbz80");
    IS(opts.cpu(), CPU_GBZ80);
    NOK(opts.lib_for_all_cpus());
    IS(opts.symbol_value("__CPU_Z80__"), 0);
    IS(opts.symbol_value("__CPU_Z80_STRICT__"), 0);
    IS(opts.symbol_value("__CPU_Z80N__"), 0);
    IS(opts.symbol_value("__CPU_Z180__"), 0);
    IS(opts.symbol_value("__CPU_EZ80__"), 0);
    IS(opts.symbol_value("__CPU_EZ80_Z80__"), 0);
    IS(opts.symbol_value("__CPU_ZILOG__"), 0);
    IS(opts.symbol_value("__CPU_R800__"), 0);
    IS(opts.symbol_value("__CPU_R2KA__"), 0);
    IS(opts.symbol_value("__CPU_R3K__"), 0);
    IS(opts.symbol_value("__CPU_R4K__"), 0);
    IS(opts.symbol_value("__CPU_R5K__"), 0);
    IS(opts.symbol_value("__CPU_RABBIT__"), 0);
    IS(opts.symbol_value("__CPU_8080__"), 0);
    IS(opts.symbol_value("__CPU_8085__"), 0);
    IS(opts.symbol_value("__CPU_INTEL__"), 0);
    IS(opts.symbol_value("__CPU_GBZ80__"), 1);
    IS(opts.symbol_value("__CPU_KC160__"), 0);
    IS(opts.symbol_value("__CPU_KC160_Z80__"), 0);
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.set_cpu("r2ka");
    IS(opts.cpu(), CPU_R2KA);
    NOK(opts.lib_for_all_cpus());
    IS(opts.symbol_value("__CPU_Z80__"), 0);
    IS(opts.symbol_value("__CPU_Z80_STRICT__"), 0);
    IS(opts.symbol_value("__CPU_Z80N__"), 0);
    IS(opts.symbol_value("__CPU_Z180__"), 0);
    IS(opts.symbol_value("__CPU_EZ80__"), 0);
    IS(opts.symbol_value("__CPU_EZ80_Z80__"), 0);
    IS(opts.symbol_value("__CPU_ZILOG__"), 0);
    IS(opts.symbol_value("__CPU_R800__"), 0);
    IS(opts.symbol_value("__CPU_R2KA__"), 1);
    IS(opts.symbol_value("__CPU_R3K__"), 0);
    IS(opts.symbol_value("__CPU_R4K__"), 0);
    IS(opts.symbol_value("__CPU_R5K__"), 0);
    IS(opts.symbol_value("__CPU_RABBIT__"), 1);
    IS(opts.symbol_value("__CPU_8080__"), 0);
    IS(opts.symbol_value("__CPU_8085__"), 0);
    IS(opts.symbol_value("__CPU_INTEL__"), 0);
    IS(opts.symbol_value("__CPU_GBZ80__"), 0);
    IS(opts.symbol_value("__CPU_KC160__"), 0);
    IS(opts.symbol_value("__CPU_KC160_Z80__"), 0);
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.set_cpu("r3k");
    IS(opts.cpu(), CPU_R3K);
    NOK(opts.lib_for_all_cpus());
    IS(opts.symbol_value("__CPU_Z80__"), 0);
    IS(opts.symbol_value("__CPU_Z80_STRICT__"), 0);
    IS(opts.symbol_value("__CPU_Z80N__"), 0);
    IS(opts.symbol_value("__CPU_Z180__"), 0);
    IS(opts.symbol_value("__CPU_EZ80__"), 0);
    IS(opts.symbol_value("__CPU_EZ80_Z80__"), 0);
    IS(opts.symbol_value("__CPU_ZILOG__"), 0);
    IS(opts.symbol_value("__CPU_R800__"), 0);
    IS(opts.symbol_value("__CPU_R2KA__"), 0);
    IS(opts.symbol_value("__CPU_R3K__"), 1);
    IS(opts.symbol_value("__CPU_R4K__"), 0);
    IS(opts.symbol_value("__CPU_R5K__"), 0);
    IS(opts.symbol_value("__CPU_RABBIT__"), 1);
    IS(opts.symbol_value("__CPU_8080__"), 0);
    IS(opts.symbol_value("__CPU_8085__"), 0);
    IS(opts.symbol_value("__CPU_INTEL__"), 0);
    IS(opts.symbol_value("__CPU_GBZ80__"), 0);
    IS(opts.symbol_value("__CPU_KC160__"), 0);
    IS(opts.symbol_value("__CPU_KC160_Z80__"), 0);
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.set_cpu("r4k");
    IS(opts.cpu(), CPU_R4K);
    NOK(opts.lib_for_all_cpus());
    IS(opts.symbol_value("__CPU_Z80__"), 0);
    IS(opts.symbol_value("__CPU_Z80_STRICT__"), 0);
    IS(opts.symbol_value("__CPU_Z80N__"), 0);
    IS(opts.symbol_value("__CPU_Z180__"), 0);
    IS(opts.symbol_value("__CPU_EZ80__"), 0);
    IS(opts.symbol_value("__CPU_EZ80_Z80__"), 0);
    IS(opts.symbol_value("__CPU_ZILOG__"), 0);
    IS(opts.symbol_value("__CPU_R800__"), 0);
    IS(opts.symbol_value("__CPU_R2KA__"), 0);
    IS(opts.symbol_value("__CPU_R3K__"), 0);
    IS(opts.symbol_value("__CPU_R4K__"), 1);
    IS(opts.symbol_value("__CPU_R5K__"), 0);
    IS(opts.symbol_value("__CPU_RABBIT__"), 1);
    IS(opts.symbol_value("__CPU_8080__"), 0);
    IS(opts.symbol_value("__CPU_8085__"), 0);
    IS(opts.symbol_value("__CPU_INTEL__"), 0);
    IS(opts.symbol_value("__CPU_GBZ80__"), 0);
    IS(opts.symbol_value("__CPU_KC160__"), 0);
    IS(opts.symbol_value("__CPU_KC160_Z80__"), 0);
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.set_cpu("r5k");
    IS(opts.cpu(), CPU_R5K);
    NOK(opts.lib_for_all_cpus());
    IS(opts.symbol_value("__CPU_Z80__"), 0);
    IS(opts.symbol_value("__CPU_Z80_STRICT__"), 0);
    IS(opts.symbol_value("__CPU_Z80N__"), 0);
    IS(opts.symbol_value("__CPU_Z180__"), 0);
    IS(opts.symbol_value("__CPU_EZ80__"), 0);
    IS(opts.symbol_value("__CPU_EZ80_Z80__"), 0);
    IS(opts.symbol_value("__CPU_ZILOG__"), 0);
    IS(opts.symbol_value("__CPU_R800__"), 0);
    IS(opts.symbol_value("__CPU_R2KA__"), 0);
    IS(opts.symbol_value("__CPU_R3K__"), 0);
    IS(opts.symbol_value("__CPU_R4K__"), 0);
    IS(opts.symbol_value("__CPU_R5K__"), 1);
    IS(opts.symbol_value("__CPU_RABBIT__"), 1);
    IS(opts.symbol_value("__CPU_8080__"), 0);
    IS(opts.symbol_value("__CPU_8085__"), 0);
    IS(opts.symbol_value("__CPU_INTEL__"), 0);
    IS(opts.symbol_value("__CPU_GBZ80__"), 0);
    IS(opts.symbol_value("__CPU_KC160__"), 0);
    IS(opts.symbol_value("__CPU_KC160_Z80__"), 0);
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.set_cpu("8080");
    IS(opts.cpu(), CPU_8080);
    NOK(opts.lib_for_all_cpus());
    IS(opts.symbol_value("__CPU_Z80__"), 0);
    IS(opts.symbol_value("__CPU_Z80_STRICT__"), 0);
    IS(opts.symbol_value("__CPU_Z80N__"), 0);
    IS(opts.symbol_value("__CPU_Z180__"), 0);
    IS(opts.symbol_value("__CPU_EZ80__"), 0);
    IS(opts.symbol_value("__CPU_EZ80_Z80__"), 0);
    IS(opts.symbol_value("__CPU_ZILOG__"), 0);
    IS(opts.symbol_value("__CPU_R800__"), 0);
    IS(opts.symbol_value("__CPU_R2KA__"), 0);
    IS(opts.symbol_value("__CPU_R3K__"), 0);
    IS(opts.symbol_value("__CPU_R4K__"), 0);
    IS(opts.symbol_value("__CPU_R5K__"), 0);
    IS(opts.symbol_value("__CPU_RABBIT__"), 0);
    IS(opts.symbol_value("__CPU_8080__"), 1);
    IS(opts.symbol_value("__CPU_8085__"), 0);
    IS(opts.symbol_value("__CPU_INTEL__"), 1);
    IS(opts.symbol_value("__CPU_GBZ80__"), 0);
    IS(opts.symbol_value("__CPU_KC160__"), 0);
    IS(opts.symbol_value("__CPU_KC160_Z80__"), 0);
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.set_cpu("8085");
    IS(opts.cpu(), CPU_8085);
    NOK(opts.lib_for_all_cpus());
    IS(opts.symbol_value("__CPU_Z80__"), 0);
    IS(opts.symbol_value("__CPU_Z80_STRICT__"), 0);
    IS(opts.symbol_value("__CPU_Z80N__"), 0);
    IS(opts.symbol_value("__CPU_Z180__"), 0);
    IS(opts.symbol_value("__CPU_EZ80__"), 0);
    IS(opts.symbol_value("__CPU_EZ80_Z80__"), 0);
    IS(opts.symbol_value("__CPU_ZILOG__"), 0);
    IS(opts.symbol_value("__CPU_R800__"), 0);
    IS(opts.symbol_value("__CPU_R2KA__"), 0);
    IS(opts.symbol_value("__CPU_R3K__"), 0);
    IS(opts.symbol_value("__CPU_R4K__"), 0);
    IS(opts.symbol_value("__CPU_R5K__"), 0);
    IS(opts.symbol_value("__CPU_RABBIT__"), 0);
    IS(opts.symbol_value("__CPU_8080__"), 0);
    IS(opts.symbol_value("__CPU_8085__"), 1);
    IS(opts.symbol_value("__CPU_INTEL__"), 1);
    IS(opts.symbol_value("__CPU_GBZ80__"), 0);
    IS(opts.symbol_value("__CPU_KC160__"), 0);
    IS(opts.symbol_value("__CPU_KC160_Z80__"), 0);
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.set_cpu("r800");
    IS(opts.cpu(), CPU_R800);
    NOK(opts.lib_for_all_cpus());
    IS(opts.symbol_value("__CPU_Z80__"), 0);
    IS(opts.symbol_value("__CPU_Z80_STRICT__"), 0);
    IS(opts.symbol_value("__CPU_Z80N__"), 0);
    IS(opts.symbol_value("__CPU_Z180__"), 0);
    IS(opts.symbol_value("__CPU_EZ80__"), 0);
    IS(opts.symbol_value("__CPU_EZ80_Z80__"), 0);
    IS(opts.symbol_value("__CPU_ZILOG__"), 0);
    IS(opts.symbol_value("__CPU_R800__"), 1);
    IS(opts.symbol_value("__CPU_R2KA__"), 0);
    IS(opts.symbol_value("__CPU_R3K__"), 0);
    IS(opts.symbol_value("__CPU_R4K__"), 0);
    IS(opts.symbol_value("__CPU_R5K__"), 0);
    IS(opts.symbol_value("__CPU_RABBIT__"), 0);
    IS(opts.symbol_value("__CPU_8080__"), 0);
    IS(opts.symbol_value("__CPU_8085__"), 0);
    IS(opts.symbol_value("__CPU_INTEL__"), 0);
    IS(opts.symbol_value("__CPU_GBZ80__"), 0);
    IS(opts.symbol_value("__CPU_KC160__"), 0);
    IS(opts.symbol_value("__CPU_KC160_Z80__"), 0);
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.set_cpu("kc160");
    IS(opts.cpu(), CPU_KC160);
    NOK(opts.lib_for_all_cpus());
    IS(opts.symbol_value("__CPU_Z80__"), 0);
    IS(opts.symbol_value("__CPU_Z80_STRICT__"), 0);
    IS(opts.symbol_value("__CPU_Z80N__"), 0);
    IS(opts.symbol_value("__CPU_Z180__"), 0);
    IS(opts.symbol_value("__CPU_EZ80__"), 0);
    IS(opts.symbol_value("__CPU_EZ80_Z80__"), 0);
    IS(opts.symbol_value("__CPU_ZILOG__"), 0);
    IS(opts.symbol_value("__CPU_R800__"), 0);
    IS(opts.symbol_value("__CPU_R2KA__"), 0);
    IS(opts.symbol_value("__CPU_R3K__"), 0);
    IS(opts.symbol_value("__CPU_R4K__"), 0);
    IS(opts.symbol_value("__CPU_R5K__"), 0);
    IS(opts.symbol_value("__CPU_RABBIT__"), 0);
    IS(opts.symbol_value("__CPU_8080__"), 0);
    IS(opts.symbol_value("__CPU_8085__"), 0);
    IS(opts.symbol_value("__CPU_INTEL__"), 0);
    IS(opts.symbol_value("__CPU_GBZ80__"), 0);
    IS(opts.symbol_value("__CPU_KC160__"), 1);
    IS(opts.symbol_value("__CPU_KC160_Z80__"), 0);
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.set_cpu("kc160_z80");
    IS(opts.cpu(), CPU_KC160_Z80);
    NOK(opts.lib_for_all_cpus());
    IS(opts.symbol_value("__CPU_Z80__"), 0);
    IS(opts.symbol_value("__CPU_Z80_STRICT__"), 0);
    IS(opts.symbol_value("__CPU_Z80N__"), 0);
    IS(opts.symbol_value("__CPU_Z180__"), 0);
    IS(opts.symbol_value("__CPU_EZ80__"), 0);
    IS(opts.symbol_value("__CPU_EZ80_Z80__"), 0);
    IS(opts.symbol_value("__CPU_ZILOG__"), 0);
    IS(opts.symbol_value("__CPU_R800__"), 0);
    IS(opts.symbol_value("__CPU_R2KA__"), 0);
    IS(opts.symbol_value("__CPU_R3K__"), 0);
    IS(opts.symbol_value("__CPU_R4K__"), 0);
    IS(opts.symbol_value("__CPU_R5K__"), 0);
    IS(opts.symbol_value("__CPU_RABBIT__"), 0);
    IS(opts.symbol_value("__CPU_8080__"), 0);
    IS(opts.symbol_value("__CPU_8085__"), 0);
    IS(opts.symbol_value("__CPU_INTEL__"), 0);
    IS(opts.symbol_value("__CPU_GBZ80__"), 0);
    IS(opts.symbol_value("__CPU_KC160__"), 0);
    IS(opts.symbol_value("__CPU_KC160_Z80__"), 1);
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.set_cpu("ti83");
    IS(opts.cpu(), CPU_Z80_STRICT);
    NOK(opts.lib_for_all_cpus());
    IS(opts.symbol_value("__CPU_Z80__"), 0);
    IS(opts.symbol_value("__CPU_Z80_STRICT__"), 1);
    IS(opts.symbol_value("__CPU_Z80N__"), 0);
    IS(opts.symbol_value("__CPU_Z180__"), 0);
    IS(opts.symbol_value("__CPU_EZ80__"), 0);
    IS(opts.symbol_value("__CPU_EZ80_Z80__"), 0);
    IS(opts.symbol_value("__CPU_ZILOG__"), 1);
    IS(opts.symbol_value("__CPU_R800__"), 0);
    IS(opts.symbol_value("__CPU_R2KA__"), 0);
    IS(opts.symbol_value("__CPU_R3K__"), 0);
    IS(opts.symbol_value("__CPU_R4K__"), 0);
    IS(opts.symbol_value("__CPU_R5K__"), 0);
    IS(opts.symbol_value("__CPU_RABBIT__"), 0);
    IS(opts.symbol_value("__CPU_8080__"), 0);
    IS(opts.symbol_value("__CPU_8085__"), 0);
    IS(opts.symbol_value("__CPU_INTEL__"), 0);
    IS(opts.symbol_value("__CPU_GBZ80__"), 0);
    IS(opts.symbol_value("__CPU_KC160__"), 0);
    IS(opts.symbol_value("__CPU_KC160_Z80__"), 0);
    OK(opts.ti83());
    NOK(opts.ti83plus());

    opts.set_cpu("ti83plus");
    IS(opts.cpu(), CPU_Z80_STRICT);
    NOK(opts.lib_for_all_cpus());
    IS(opts.symbol_value("__CPU_Z80__"), 0);
    IS(opts.symbol_value("__CPU_Z80_STRICT__"), 1);
    IS(opts.symbol_value("__CPU_Z80N__"), 0);
    IS(opts.symbol_value("__CPU_Z180__"), 0);
    IS(opts.symbol_value("__CPU_EZ80__"), 0);
    IS(opts.symbol_value("__CPU_EZ80_Z80__"), 0);
    IS(opts.symbol_value("__CPU_ZILOG__"), 1);
    IS(opts.symbol_value("__CPU_R800__"), 0);
    IS(opts.symbol_value("__CPU_R2KA__"), 0);
    IS(opts.symbol_value("__CPU_R3K__"), 0);
    IS(opts.symbol_value("__CPU_R4K__"), 0);
    IS(opts.symbol_value("__CPU_R5K__"), 0);
    IS(opts.symbol_value("__CPU_RABBIT__"), 0);
    IS(opts.symbol_value("__CPU_8080__"), 0);
    IS(opts.symbol_value("__CPU_8085__"), 0);
    IS(opts.symbol_value("__CPU_INTEL__"), 0);
    IS(opts.symbol_value("__CPU_GBZ80__"), 0);
    IS(opts.symbol_value("__CPU_KC160__"), 0);
    IS(opts.symbol_value("__CPU_KC160_Z80__"), 0);
    NOK(opts.ti83());
    OK(opts.ti83plus());
}

void test_option_cpu4() {
    Options opts;

    opts.parse_option("-m*");
    IS(opts.cpu(), CPU_Z80);
    OK(opts.lib_for_all_cpus());
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.parse_option("-mz80");
    IS(opts.cpu(), CPU_Z80);
    NOK(opts.lib_for_all_cpus());
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.parse_option("-mz80_strict");
    IS(opts.cpu(), CPU_Z80_STRICT);
    NOK(opts.lib_for_all_cpus());
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.parse_option("-mz180");
    IS(opts.cpu(), CPU_Z180);
    NOK(opts.lib_for_all_cpus());
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.parse_option("-mez80_z80");
    IS(opts.cpu(), CPU_EZ80_Z80);
    NOK(opts.lib_for_all_cpus());
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.parse_option("-mez80");
    IS(opts.cpu(), CPU_EZ80);
    NOK(opts.lib_for_all_cpus());
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.parse_option("-mz80n");
    IS(opts.cpu(), CPU_Z80N);
    NOK(opts.lib_for_all_cpus());
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.parse_option("-mgbz80");
    IS(opts.cpu(), CPU_GBZ80);
    NOK(opts.lib_for_all_cpus());
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.parse_option("-mr2ka");
    IS(opts.cpu(), CPU_R2KA);
    NOK(opts.lib_for_all_cpus());
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.parse_option("-mr3k");
    IS(opts.cpu(), CPU_R3K);
    NOK(opts.lib_for_all_cpus());
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.parse_option("-mr4k");
    IS(opts.cpu(), CPU_R4K);
    NOK(opts.lib_for_all_cpus());
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.parse_option("-mr5k");
    IS(opts.cpu(), CPU_R5K);
    NOK(opts.lib_for_all_cpus());
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.parse_option("-m8080");
    IS(opts.cpu(), CPU_8080);
    NOK(opts.lib_for_all_cpus());
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.parse_option("-m8085");
    IS(opts.cpu(), CPU_8085);
    NOK(opts.lib_for_all_cpus());
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.parse_option("-mr800");
    IS(opts.cpu(), CPU_R800);
    NOK(opts.lib_for_all_cpus());
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.parse_option("-mkc160");
    IS(opts.cpu(), CPU_KC160);
    NOK(opts.lib_for_all_cpus());
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.parse_option("-mkc160_z80");
    IS(opts.cpu(), CPU_KC160_Z80);
    NOK(opts.lib_for_all_cpus());
    NOK(opts.ti83());
    NOK(opts.ti83plus());

    opts.parse_option("-mti83");
    IS(opts.cpu(), CPU_Z80_STRICT);
    NOK(opts.lib_for_all_cpus());
    OK(opts.ti83());
    NOK(opts.ti83plus());

    opts.parse_option("-mti83plus");
    IS(opts.cpu(), CPU_Z80_STRICT);
    NOK(opts.lib_for_all_cpus());
    NOK(opts.ti83());
    OK(opts.ti83plus());

}

void test_option_swap_ixiy() {
    Options opts;

    IS(opts.swap_ixiy(), IXIY_NO_SWAP);
    IS(opts.symbol_value("__SWAP_IX_IY__"), 0);

    opts.set_swap_ixiy(IXIY_SWAP);
    IS(opts.swap_ixiy(), IXIY_SWAP);
    IS(opts.symbol_value("__SWAP_IX_IY__"), 1);

    opts.set_swap_ixiy(IXIY_SOFT_SWAP);
    IS(opts.swap_ixiy(), IXIY_SOFT_SWAP);
    IS(opts.symbol_value("__SWAP_IX_IY__"), 1);

    opts.parse_option("-IXIY");
    IS(opts.swap_ixiy(), IXIY_SWAP);
    IS(opts.symbol_value("__SWAP_IX_IY__"), 1);

    opts.parse_option("-IXIY-soft");
    IS(opts.swap_ixiy(), IXIY_SOFT_SWAP);
    IS(opts.symbol_value("__SWAP_IX_IY__"), 1);
}

void test_option_verbose() {
    RUN_OK("exec_option_verbose1");
    OUT_IS(
        "% z88dk-z80asm -v -IXIY test~.asm\n"
        "Predefined constant: __CPU_Z80__ = 1\n"
        "Predefined constant: __CPU_ZILOG__ = 1\n"
        "Predefined constant: __SWAP_IX_IY__ = 1\n"
        "Predefined constant: __FLOAT_GENMATH__ = 1\n"
        "Reading library 'z88dk-z80asm.lib'\n");
    ERR_IS("");

    RUN_OK("exec_option_verbose2");
    OUT_IS(
        "Z80ASM=-v\n"
        "% z88dk-z80asm test~.asm\n"
        "Predefined constant: __CPU_Z80__ = 1\n"
        "Predefined constant: __CPU_ZILOG__ = 1\n"
        "Predefined constant: __FLOAT_GENMATH__ = 1\n"
        "Reading library 'z88dk-z80asm.lib'\n");
    ERR_IS("");
}

int exec_option_verbose1() {
    Options opts;

    test_spew("test~.asm", "");
    test_spew("z88dk-z80asm.lib", LIB_FILE_SIGNATURE TOSTR(OBJ_FILE_VERSION) "xx");
    opts.parse_args({ "-v", "-IXIY", "test~.asm" });
    remove("test~.asm");
    remove("z88dk-z80asm.lib");
    return g_asm.exit_code();
}

int exec_option_verbose2() {
    Options opts;

    xassert(0 == putenv((char*)"Z80ASM=-v"));
    test_spew("test~.asm", "");
    test_spew("z88dk-z80asm.lib", LIB_FILE_SIGNATURE TOSTR(OBJ_FILE_VERSION) "xx");
    opts.parse_args({ "test~.asm" });
    remove("test~.asm");
    remove("z88dk-z80asm.lib");
    xassert(0 == putenv((char*)"Z80ASM="));
    return g_asm.exit_code();
}

void test_option_lib_filename() {
    Options opts;
    OK(opts.lib_filename().empty());

    opts.parse_option("-xtest");
    IS(opts.lib_filename(), "test.lib");

    opts.parse_option("-xtest.asm");
    IS(opts.lib_filename(), "test.lib");

    opts.parse_option("-xtest.asm.lib");
    IS(opts.lib_filename(), "test.asm.lib");

    opts.parse_option("-xtest.lib");
    IS(opts.lib_filename(), "test.lib");
}

void test_option_output_dir() {
    Options opts;
    OK(opts.output_dir().empty());

    fs::remove_all("test~.dir");
    OK(!file_is_directory("test~.dir"));

    test_spew("test~.asm", "");
    opts.parse_args({ "-Otest~.dir", "test~.asm" });

    IS(opts.output_dir(),"test~.dir");
    OK(file_is_directory("test~.dir"));

    fs::remove_all("test~.dir");
    remove("test~.asm");
}

void test_option_bin_filename() {
    Options opts;
    OK(opts.bin_filename().empty());

    opts.set_bin_filename("test");
    IS(opts.bin_filename(), "test");

    opts.set_bin_filename("test.bin");
    IS(opts.bin_filename(), "test.bin");

    opts.parse_option("-otest");
    IS(opts.bin_filename(), "test");

    opts.parse_option("-otest.bin");
    IS(opts.bin_filename(), "test.bin");
}

void test_option_origin1() {
    RUN_NOK("exec_option_origin1");
    OUT_IS("");
    ERR_IS("error: illegal option: -r\n");

    RUN_NOK("exec_option_origin2");
    OUT_IS("");
    ERR_IS("error: illegal option: -r=\n");

    RUN_NOK("exec_option_origin3");
    OUT_IS("");
    ERR_IS("error: invalid origin (-r) option: $\n");

    RUN_NOK("exec_option_origin4");
    OUT_IS("");
    ERR_IS("error: invalid origin (-r) option: -1\n");
}

void test_option_origin2() {
    Options opts;

    opts.parse_option("-r1");
    IS(opts.origin(), 1);

    opts.parse_option("-r+2");
    IS(opts.origin(), 2);

    opts.parse_option("-r+--3");
    IS(opts.origin(), 3);

    opts.parse_option("-r=4");
    IS(opts.origin(), 4);

    opts.parse_option("-r=$5f");
    IS(opts.origin(), 0x5f);

    opts.parse_option("-r=$6F");
    IS(opts.origin(), 0x6f);

    opts.parse_option("-r=7fh");
    IS(opts.origin(), 0x7f);

    opts.parse_option("-r=8FH");
    IS(opts.origin(), 0x8f);
}

int exec_option_origin1() {
    Options opts;

    opts.parse_option("-r");
    return g_asm.exit_code();
}

int exec_option_origin2() {
    Options opts;

    opts.parse_option("-r=");
    return g_asm.exit_code();
}

int exec_option_origin3() {
    Options opts;

    opts.parse_option("-r=$");
    return g_asm.exit_code();
}

int exec_option_origin4() {
    Options opts;

    opts.parse_option("-r=-1");
    return g_asm.exit_code();
}

void test_option_filler1() {
    RUN_NOK("exec_option_filler1");
    OUT_IS("");
    ERR_IS("error: illegal option: -f\n");

    RUN_NOK("exec_option_filler2");
    OUT_IS("");
    ERR_IS("error: illegal option: -f=\n");

    RUN_NOK("exec_option_filler3");
    OUT_IS("");
    ERR_IS("error: invalid filler (-f) option: $\n");

    RUN_NOK("exec_option_filler4");
    OUT_IS("");
    ERR_IS("error: invalid filler (-f) option: -1\n");

    RUN_NOK("exec_option_filler5");
    OUT_IS("");
    ERR_IS("error: invalid filler (-f) option: $100\n");
}

void test_option_filler2() {
    Options opts;

    opts.parse_option("-f1");
    IS(opts.filler(), 1);

    opts.parse_option("-f+2");
    IS(opts.filler(), 2);

    opts.parse_option("-f+--3");
    IS(opts.filler(), 3);

    opts.parse_option("-f=4");
    IS(opts.filler(), 4);

    opts.parse_option("-f=$5f");
    IS(opts.filler(), 0x5f);

    opts.parse_option("-f=$6F");
    IS(opts.filler(), 0x6f);

    opts.parse_option("-f=7fh");
    IS(opts.filler(), 0x7f);

    opts.parse_option("-f=8FH");
    IS(opts.filler(), 0x8f);
}

int exec_option_filler1() {
    Options opts;

    opts.parse_option("-f");
    return g_asm.exit_code();
}

int exec_option_filler2() {
    Options opts;

    opts.parse_option("-f=");
    return g_asm.exit_code();
}

int exec_option_filler3() {
    Options opts;

    opts.parse_option("-f=$");
    return g_asm.exit_code();
}

int exec_option_filler4() {
    Options opts;

    opts.parse_option("-f=-1");
    return g_asm.exit_code();
}

int exec_option_filler5() {
    Options opts;

    opts.parse_option("-f=$100");
    return g_asm.exit_code();
}

void test_option_appmake() {
    Options opts;
    opts.parse_option("+zx81");
    IS(opts.appmake(), APPMAKE_ZX81);
    OK(opts.make_bin());
    IS(opts.origin(), 16514);
    IS(opts.float_format().get(), FLOAT_zx81);

    opts = Options();
    opts.parse_option("+zx");
    IS(opts.appmake(), APPMAKE_ZX);
    OK(opts.make_bin());
    IS(opts.origin(), 23760);
    IS(opts.float_format().get(), FLOAT_zx);
}

void test_option_m4() {
    Options opts;
    opts.parse_option("-m4=1");
    opts.parse_option("-m4=2");
    opts.parse_option("-m4=3");
    IS(opts.m4_options(), "1 2 3 ");
}

void test_option_include_path() {
    Options opts;
    opts.include_path().clear();
    opts.parse_option("-Ix");
    opts.parse_option("-Iy");
    opts.parse_option("-Iz");
    IS(opts.include_path().size(), 3);
    IS(opts.include_path()[0], "x");
    IS(opts.include_path()[1], "y");
    IS(opts.include_path()[2], "z");
}

void test_option_library_path() {
    Options opts;
    opts.library_path().clear();
    opts.parse_option("-Lx");
    opts.parse_option("-Ly");
    opts.parse_option("-Lz");
    IS(opts.library_path().size(), 3);
    IS(opts.library_path()[0], "x");
    IS(opts.library_path()[1], "y");
    IS(opts.library_path()[2], "z");
}

void test_option_library() {
    Options opts;
    fs::create_directories("test~.dir");
    test_spew("test~1.lib", LIB_FILE_SIGNATURE TOSTR(OBJ_FILE_VERSION) "xx");
    test_spew("test~.dir/test~2.lib", LIB_FILE_SIGNATURE TOSTR(OBJ_FILE_VERSION) "xx");

    opts.parse_option("-Ltest~.dir");
    opts.parse_option("-ltest~1");
    opts.parse_option("-ltest~2.lib");

    IS(opts.libraries().size(), 2);
    IS(opts.libraries()[0], "test~1.lib");
    IS(opts.libraries()[1], "test~.dir/test~2.lib");

    fs::remove_all("test~.dir");
    remove("test~1.lib");
}

void test_option_consol_obj_filename() {
    Options opts;

    test_spew("test~.asm", "");

    opts = Options();
    OK(opts.consol_obj_filename().empty());

    opts = Options();
    opts.parse_args({ "test~.asm" });
    OK(opts.consol_obj_filename().empty());

    opts = Options();
    opts.parse_args({ "-b", "test~.asm" });
    OK(opts.consol_obj_filename().empty());

    opts = Options();
    opts.parse_args({ "-b", "-otest~.o", "test~.asm" });
    OK(opts.consol_obj_filename().empty());

    opts = Options();
    opts.parse_args({ "-otest~.o", "test~.asm" });
    IS(opts.consol_obj_filename(),"test~.o");

    remove("test~.asm");
}

void test_option_defines() {
    Options opts;
    opts.symbol_define("X", 1);
    opts.symbol_define("Y", 2);
    opts.symbol_define("Z", 3);

    OK(opts.symbol_exists("X"));
    OK(opts.symbol_exists("Y"));
    OK(opts.symbol_exists("Z"));

    IS(opts.symbol_value("X"), 1);
    IS(opts.symbol_value("Y"), 2);
    IS(opts.symbol_value("Z"), 3);

    opts.symbol_undefine("Z");

    OK(opts.symbol_exists("X"));
    OK(opts.symbol_exists("Y"));
    NOK(opts.symbol_exists("Z"));

    IS(opts.symbol_value("X"), 1);
    IS(opts.symbol_value("Y"), 2);
    IS(opts.symbol_value("Z"), 0);

    IS(opts.defines().size(), 2);
    for (auto& define : opts.defines()) {
        if (define.first == "X")
            IS(define.second, 1);
        else if (define.first == "Y")
            IS(define.second, 2);
        else
            FAIL();
    }
}

void test_option_float_format1() {
    Options opts;

    opts.set_float_format(FLOAT_genmath);
    IS(opts.float_format().get(), FLOAT_genmath);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 1);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.set_float_format(FLOAT_math48);
    IS(opts.float_format().get(), FLOAT_math48);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 1);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.set_float_format(FLOAT_ieee16);
    IS(opts.float_format().get(), FLOAT_ieee16);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 1);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.set_float_format(FLOAT_ieee32);
    IS(opts.float_format().get(), FLOAT_ieee32);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 1);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.set_float_format(FLOAT_ieee64);
    IS(opts.float_format().get(), FLOAT_ieee64);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 1);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.set_float_format(FLOAT_z80);
    IS(opts.float_format().get(), FLOAT_z80);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 1);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.set_float_format(FLOAT_zx81);
    IS(opts.float_format().get(), FLOAT_zx81);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 1);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.set_float_format(FLOAT_zx);
    IS(opts.float_format().get(), FLOAT_zx);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 1);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.set_float_format(FLOAT_z88);
    IS(opts.float_format().get(), FLOAT_z88);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 1);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.set_float_format(FLOAT_mbfs);
    IS(opts.float_format().get(), FLOAT_mbfs);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 1);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.set_float_format(FLOAT_mbf40);
    IS(opts.float_format().get(), FLOAT_mbf40);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 1);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.set_float_format(FLOAT_mbf64);
    IS(opts.float_format().get(), FLOAT_mbf64);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 1);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.set_float_format(FLOAT_am9511);
    IS(opts.float_format().get(), FLOAT_am9511);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 1);
}

void test_option_float_format2() {
    Options opts;

    opts.set_float_format("genmath");
    IS(opts.float_format().get(), FLOAT_genmath);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 1);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.set_float_format("math48");
    IS(opts.float_format().get(), FLOAT_math48);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 1);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.set_float_format("ieee16");
    IS(opts.float_format().get(), FLOAT_ieee16);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 1);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.set_float_format("ieee32");
    IS(opts.float_format().get(), FLOAT_ieee32);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 1);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.set_float_format("ieee64");
    IS(opts.float_format().get(), FLOAT_ieee64);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 1);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.set_float_format("z80");
    IS(opts.float_format().get(), FLOAT_z80);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 1);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.set_float_format("zx81");
    IS(opts.float_format().get(), FLOAT_zx81);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 1);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.set_float_format("zx");
    IS(opts.float_format().get(), FLOAT_zx);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 1);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.set_float_format("z88");
    IS(opts.float_format().get(), FLOAT_z88);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 1);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.set_float_format("mbfs");
    IS(opts.float_format().get(), FLOAT_mbfs);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 1);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.set_float_format("mbf40");
    IS(opts.float_format().get(), FLOAT_mbf40);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 1);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.set_float_format("mbf64");
    IS(opts.float_format().get(), FLOAT_mbf64);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 1);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.set_float_format("am9511");
    IS(opts.float_format().get(), FLOAT_am9511);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 1);
}

void test_option_float_format3() {
    Options opts;

    opts.parse_option("-float=genmath");
    IS(opts.float_format().get(), FLOAT_genmath);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 1);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.parse_option("-float=math48");
    IS(opts.float_format().get(), FLOAT_math48);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 1);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.parse_option("-float=ieee16");
    IS(opts.float_format().get(), FLOAT_ieee16);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 1);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.parse_option("-float=ieee32");
    IS(opts.float_format().get(), FLOAT_ieee32);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 1);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.parse_option("-float=ieee64");
    IS(opts.float_format().get(), FLOAT_ieee64);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 1);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.parse_option("-float=z80");
    IS(opts.float_format().get(), FLOAT_z80);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 1);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.parse_option("-float=zx81");
    IS(opts.float_format().get(), FLOAT_zx81);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 1);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.parse_option("-float=zx");
    IS(opts.float_format().get(), FLOAT_zx);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 1);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.parse_option("-float=z88");
    IS(opts.float_format().get(), FLOAT_z88);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 1);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.parse_option("-float=mbfs");
    IS(opts.float_format().get(), FLOAT_mbfs);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 1);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.parse_option("-float=mbf40");
    IS(opts.float_format().get(), FLOAT_mbf40);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 1);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.parse_option("-float=mbf64");
    IS(opts.float_format().get(), FLOAT_mbf64);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 1);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 0);

    opts.parse_option("-float=am9511");
    IS(opts.float_format().get(), FLOAT_am9511);
    IS(opts.symbol_value("__FLOAT_GENMATH__"), 0);
    IS(opts.symbol_value("__FLOAT_MATH48__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE16__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE32__"), 0);
    IS(opts.symbol_value("__FLOAT_IEEE64__"), 0);
    IS(opts.symbol_value("__FLOAT_Z80__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX81__"), 0);
    IS(opts.symbol_value("__FLOAT_ZX__"), 0);
    IS(opts.symbol_value("__FLOAT_Z88__"), 0);
    IS(opts.symbol_value("__FLOAT_MBFS__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF40__"), 0);
    IS(opts.symbol_value("__FLOAT_MBF64__"), 0);
    IS(opts.symbol_value("__FLOAT_AM9511__"), 1);
}

void test_option_float_format4() {
    RUN_NOK("exec_option_float_format");
    OUT_IS("");
    ERR_IS(
        "error: illegal -float option: xpto\n"
        "error: list of available float formats: "
        "genmath,math48,ieee16,ieee32,ieee64,z80,zx81,zx,z88,"
        "mbfs,mbf40,mbf64,am9511\n");
}

int exec_option_float_format() {
    Options opts;
    opts.parse_option("-float=xpto");
    return g_asm.exit_code();
}

void test_option_input_files1() {
    remove("test~.o");
    test_spew("test~.asm", "");

    Options opts;
    opts.parse_args({ "test~" });
    IS(opts.input_files().size(), 1);
    IS(opts.input_files()[0], "test~.asm");

    opts = Options();
    opts.parse_args({ "test~.asm" });
    IS(opts.input_files().size(), 1);
    IS(opts.input_files()[0], "test~.asm");

    RUN_NOK("exec_option_input_files1");
    OUT_IS("");
    ERR_IS("error: file not found: test~.o\n");

    remove("test~.asm");
}

int exec_option_input_files1() {
    remove("test~.asm");
    remove("test~.o");

    Options opts;
    opts.parse_args({ "test~.o" });
    xassert(opts.input_files().size() == 0);
    return g_asm.exit_code();
}

void test_option_input_files2() {
    remove("test~.asm");
    remove("test~.o");
    test_spew("test~.xxx", "");

    Options opts;
    opts.parse_args({ "test~.xxx" });
    IS(opts.input_files().size(), 1);
    IS(opts.input_files()[0], "test~.xxx");

    remove("test~.xxx");
}

void test_option_input_files3() {
    remove("test~.asm");
    test_spew("test~.o", OBJ_FILE_SIGNATURE TOSTR(OBJ_FILE_VERSION) "xx");

    Options opts;
    opts.parse_args({ "test~" });
    IS(opts.input_files().size(), 1);
    IS(opts.input_files()[0], "test~.o");

    opts = Options();
    opts.parse_args({ "test~.asm" });
    IS(opts.input_files().size(), 1);
    IS(opts.input_files()[0], "test~.o");

    opts = Options();
    opts.parse_args({ "test~.o" });
    IS(opts.input_files().size(), 1);
    IS(opts.input_files()[0], "test~.o");

    remove("test~.o");
}

void test_option_input_files4() {
    remove("-test~.o");
    test_spew("-test~.asm", "");

    Options opts;
    opts.parse_args({ "--", "-test~" });
    IS(opts.input_files().size(), 1);
    IS(opts.input_files()[0], "-test~.asm");

    opts = Options();
    opts.parse_args({ "--", "-test~.asm" });
    IS(opts.input_files().size(), 1);
    IS(opts.input_files()[0], "-test~.asm");

    RUN_NOK("exec_option_input_files4");
    OUT_IS("");
    ERR_IS("error: illegal option: -test~.asm\n");

    remove("-test~.asm");
}

int exec_option_input_files4() {
    Options opts;
    opts.parse_args({ "-test~.asm" });
    xassert(opts.input_files().size() == 0);
    return g_asm.exit_code();
}

// test m4 pre-processor
void test_option_input_files5() {
    remove("test~.o");
    test_spew("test~.asm.m4",
        "define(`one', defb 1\n"
        ")\n"
        "define(`two', defb 2\n"
        ")\n"
        "define(`three', defb 3\n"
        ")\n"
        "define(`input', defb INPUT\n"
        ")\n"
        " one two three input\n");

    Options opts;
    opts.parse_args({ "-m4=-DINPUT=4", "test~.asm.m4" });
    IS(opts.input_files().size(), 1);
    IS(opts.input_files()[0], "test~.asm");
    IS(test_slurp("test~.asm"),
        "\n\n\n\n"
        " defb 1\n"
        " defb 2\n"
        " defb 3\n"
        " defb 4\n"
        "\n");

    remove("test~.asm.m4");
    remove("test~.asm");
}

void test_option_input_files6() {
    test_spew("test~.o", OBJ_FILE_SIGNATURE TOSTR(OBJ_FILE_VERSION) "xx");
    OK(0 == system("perl -e 'sleep(1)'"));
    test_spew("test~.asm", "");

    // first compiles; second skips
    Options opts;
    opts.parse_args({ "-d", "test~.asm" });
    IS(opts.input_files().size(), 1);
    IS(opts.input_files()[0], "test~.asm");

    test_spew("test~.asm", "");
    test_spew("test~.o", OBJ_FILE_SIGNATURE TOSTR(OBJ_FILE_VERSION) "xx");

    // now skips compile
    opts = Options();
    opts.parse_args({ "-d", "test~.asm" });
    IS(opts.input_files().size(), 1);
    IS(opts.input_files()[0], "test~.o");

    // remove source, give -d -> uses existing object - with extension
    remove("test~.asm");

    opts = Options();
    opts.parse_args({ "-d", "test~.asm" });
    IS(opts.input_files().size(), 1);
    IS(opts.input_files()[0], "test~.o");

    // remove source, give - d->uses existing object - without extension
    remove("test~.asm");

    opts = Options();
    opts.parse_args({ "-d", "test~" });
    IS(opts.input_files().size(), 1);
    IS(opts.input_files()[0], "test~.o");

    remove("test~.asm");
    remove("test~.o");
}

// test source @lists
void test_option_input_files7() {
    test_spew("test1~.asm", "");
    test_spew("test2~.asm", "");
    test_spew("test3~.asm", "");
    test_spew("test4~.asm", "");

    // list file with sub-list and comments
    test_spew("test1~.lst",
            "; comment followed by blank line\n"
            "\n"
            " # comment\n"
            " test2~.asm \n"
            " @ test2~.lst \n"
            " ; comment\n\n");

    // list file with different EOL chars
    test_spew("test2~.lst",
        "\r\r\n\n  "
        " test3~.asm \n"
        "  \r\r\n\n    "
        " test4~.asm \n\n");

    Options opts;
    opts.parse_args({ "test1~.asm", "@test1~.lst" });
    IS(opts.input_files().size(), 4);
    IS(opts.input_files()[0], "test1~.asm");
    IS(opts.input_files()[1], "test2~.asm");
    IS(opts.input_files()[2], "test3~.asm");
    IS(opts.input_files()[3], "test4~.asm");

    remove("test1~.asm");
    remove("test2~.asm");
    remove("test3~.asm");
    remove("test4~.asm");
    remove("test1~.lst");
    remove("test2~.lst");
}

// recursive includes
void test_option_input_files8() {
    RUN_NOK("exec_option_input_files8");
    OUT_IS("");
    ERR_IS("test2~.lst:7: error: include recursion: test1~.lst\n"
           "  ^---- @test1~.lst\n");
}

int exec_option_input_files8() {
    test_spew("test1~.asm", "");
    test_spew("test2~.asm", "");

    test_spew("test1~.lst",
        "\r\r\n\n  "
        "test1~.asm"
        "  \r\r\n\n  "
        "@test2~.lst");

    test_spew("test2~.lst",
        "\r\r\n\n  "
        "test2~.asm"
        "  \r\r\n\n  "
        "@test1~.lst");

    Options opts;
    opts.parse_args({ "@test1~.lst" });

    remove("test1~.asm");
    remove("test2~.asm");
    remove("test1~.lst");
    remove("test2~.lst");

    return g_asm.exit_code();
}

// environment variables
void test_option_input_files9() {
    RUN_OK("exec_option_input_files9");
    OUT_IS("");
    ERR_IS("");
}

int exec_option_input_files9() {
    xassert(0 == putenv((char*)"TEST=test"));

    test_spew("test1~.asm", "");
    test_spew("test2~.asm", "");
    test_spew("test1~.lst", "${TEST}2~.asm");

    Options opts;
    opts.parse_args({ "${TEST}1~.asm", "@${TEST}1~.lst" });
    xassert(opts.input_files().size() == 2);
    xassert(opts.input_files()[0] == "test1~.asm");
    xassert(opts.input_files()[1] == "test2~.asm");

    remove("test1~.asm");
    remove("test2~.asm");
    remove("test1~.lst");

    xassert(0 == putenv((char*)"TEST="));

    return g_asm.exit_code();
}

// non-existent environment variable is empty
void test_option_input_files10() {
    RUN_OK("exec_option_input_files10");
    OUT_IS("");
    ERR_IS("");
}

int exec_option_input_files10() {
    xassert(0 == putenv((char*)"TEST="));

    test_spew("test1~.asm", "");
    test_spew("test2~.asm", "");
    test_spew("test1~.lst", "test${TEST}2~.asm");

    Options opts;
    opts.parse_args({ "test${TEST}1~.asm", "@test${TEST}1~.lst" });
    xassert(opts.input_files().size() == 2);
    xassert(opts.input_files()[0] == "test1~.asm");
    xassert(opts.input_files()[1] == "test2~.asm");

    remove("test1~.asm");
    remove("test2~.asm");
    remove("test1~.lst");

    return g_asm.exit_code();
}

// use globs in command line
void test_option_input_files11() {
    test_spew("test1~.asm", "");
    test_spew("test2~.asm", "");
    test_spew("test3~.asm", "");
    test_spew("test4~.asm", "");

    Options opts;
    opts.parse_args({ "test*~.asm" });
    IS(opts.input_files().size(), 4);
    IS(opts.input_files()[0], "test1~.asm");
    IS(opts.input_files()[1], "test2~.asm");
    IS(opts.input_files()[2], "test3~.asm");
    IS(opts.input_files()[3], "test4~.asm");

    remove("test1~.asm");
    remove("test2~.asm");
    remove("test3~.asm");
    remove("test4~.asm");
}

// use globs in list file
void test_option_input_files12() {
    test_spew("test1~.asm", "");
    test_spew("test2~.asm", "");
    test_spew("test3~.asm", "");
    test_spew("test4~.asm", "");
    test_spew("test1~.lst", "test*~.asm");

    Options opts;
    opts.parse_args({ "@test1~.lst" });
    IS(opts.input_files().size(), 4);
    IS(opts.input_files()[0], "test1~.asm");
    IS(opts.input_files()[1], "test2~.asm");
    IS(opts.input_files()[2], "test3~.asm");
    IS(opts.input_files()[3], "test4~.asm");

    remove("test1~.asm");
    remove("test2~.asm");
    remove("test3~.asm");
    remove("test4~.asm");
    remove("test1~.lst");
}

// error if no files are returned
void test_option_input_files13() {
    RUN_NOK("exec_option_input_files13");
    OUT_IS("");
    ERR_IS("error: pattern returned no files: test*~.asm\n");
}

int exec_option_input_files13() {
    remove("test1~.asm");
    remove("test2~.asm");
    remove("test3~.asm");
    remove("test4~.asm");

    Options opts;
    opts.parse_args({ "test*~.asm" });

    return g_asm.exit_code();
}

// use globs in recursive list file name
void test_option_input_files14() {
    fs::create_directories("test~.dir");
    test_spew("test~.dir/test1~.asm", "");
    test_spew("test~.dir/test2~.asm", "");
    test_spew("test~.dir/test3~.asm", "");
    test_spew("test~.dir/test4~.asm", "");
    test_spew("test~.dir/test1~.lst", "test~.dir/test1~.asm");
    test_spew("test~.dir/test2~.lst", "test~.dir/test2~.asm");
    test_spew("test~.dir/test3~.lst", "test~.dir/test3~.asm");
    test_spew("test~.dir/test4~.lst", "test~.dir/test4~.asm");
    test_spew("test~.lst", "@test~.dir/test*.lst");

    Options opts;
    opts.parse_args({ "@test~.lst" });
    IS(opts.input_files().size(), 4);
    IS(opts.input_files()[0], "test~.dir/test1~.asm");
    IS(opts.input_files()[1], "test~.dir/test2~.asm");
    IS(opts.input_files()[2], "test~.dir/test3~.asm");
    IS(opts.input_files()[3], "test~.dir/test4~.asm");

    remove("test~.lst");
    fs::remove_all("test~.dir");
}

// use ** glob for any number of directories
void test_option_input_files15() {
    fs::create_directories("test~.dir/1/a");
    fs::create_directories("test~.dir/2/b");
    fs::create_directories("test~.dir/3/c");
    fs::create_directories("test~.dir/4/d");
    test_spew("test~.dir/1/a/test1~.asm", "");
    test_spew("test~.dir/2/b/test2~.asm", "");
    test_spew("test~.dir/3/c/test3~.asm", "");
    test_spew("test~.dir/4/d/test4~.asm", "");

    Options opts;
    opts.parse_args({ "test~.dir/**/*.asm" });
    IS(opts.input_files().size(), 4);
    IS(opts.input_files()[0], "test~.dir/1/a/test1~.asm");
    IS(opts.input_files()[1], "test~.dir/2/b/test2~.asm");
    IS(opts.input_files()[2], "test~.dir/3/c/test3~.asm");
    IS(opts.input_files()[3], "test~.dir/4/d/test4~.asm");

    fs::remove_all("test~.dir");
}

// source files searched in -I include path
void test_option_input_files16() {
    fs::create_directories("test~.dir");
    test_spew("test~.dir/test1~.asm", "");
    test_spew("test~.dir/test2~.asm", "");
    test_spew("test~.dir/test3~.asm", "");
    test_spew("test~.dir/test4~.asm", "");

    Options opts;
    opts.parse_args({ "-Itest~.dir", "test1~.asm", "test2~.asm", "test3~.asm", "test4~.asm" });
    IS(opts.input_files().size(), 4);
    IS(opts.input_files()[0], "test~.dir/test1~.asm");
    IS(opts.input_files()[1], "test~.dir/test2~.asm");
    IS(opts.input_files()[2], "test~.dir/test3~.asm");
    IS(opts.input_files()[3], "test~.dir/test4~.asm");

    fs::remove_all("test~.dir");
}

// @files can be searched in -I include path
void test_option_input_files17() {
    fs::create_directories("test~.dir");
    test_spew("test~.dir/test1~.asm", "");
    test_spew("test~.dir/test2~.asm", "");
    test_spew("test~.dir/test3~.asm", "");
    test_spew("test~.dir/test4~.asm", "");
    test_spew("test~.dir/test~.lst", "test~.dir/*.asm");

    Options opts;
    opts.parse_args({ "-Itest~.dir", "@test~.lst" });
    IS(opts.input_files().size(), 4);
    IS(opts.input_files()[0], "test~.dir/test1~.asm");
    IS(opts.input_files()[1], "test~.dir/test2~.asm");
    IS(opts.input_files()[2], "test~.dir/test3~.asm");
    IS(opts.input_files()[3], "test~.dir/test4~.asm");

    fs::remove_all("test~.dir");
}

// @files can be referred by relative-path
void test_option_input_files18() {
    fs::create_directories("test~.dir");
    test_spew("test~.dir/test1~.asm", "");
    test_spew("test~.dir/test2~.asm", "");
    test_spew("test~.dir/test3~.asm", "");
    test_spew("test~.dir/test4~.asm", "");
    test_spew("test~.dir/test1~.lst", "test1~.asm");
    test_spew("test~.dir/test2~.lst", "test2~.asm");
    test_spew("test~.dir/test3~.lst", "test3~.asm");
    test_spew("test~.dir/test4~.lst", "test4~.asm");
    test_spew("test~.dir/test~.lst",
        "@test1~.lst\n"
        "@test2~.lst\n"
        "@test3~.lst\n"
        "@test4~.lst\n");

    Options opts;
    opts.parse_args({ "@test~.dir/test~.lst" });
    IS(opts.input_files().size(), 4);
    IS(opts.input_files()[0], "test~.dir/test1~.asm");
    IS(opts.input_files()[1], "test~.dir/test2~.asm");
    IS(opts.input_files()[2], "test~.dir/test3~.asm");
    IS(opts.input_files()[3], "test~.dir/test4~.asm");

    fs::remove_all("test~.dir");
}

