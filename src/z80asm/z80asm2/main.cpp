//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "common.h"
#include "files.h"
#include "stack_trace.h"
#include "xmalloc.h"
#include "xassert.h"
#include <iostream>
using namespace std;

int main(int argc, char* argv[]) {
    dump_stack_on_sigsegv();
    xassert_init(argv[0]);
    xmalloc_init(argv[0]);

    // parse command line
    vector<string> args{ argv + 1, argv + argc };
    g_options().parse_args(args);
    if (g_errors().count())
        return EXIT_FAILURE;

    // asssemble required files
    if (!g_options().lib_for_all_cpus()) {
        for (auto& file : g_options().input_files()) {
            if (file_extension(file) != EXT_O)
                g_asm.assemble(file);
        }
    }
    if (g_errors().count())
        return EXIT_FAILURE;

    // call linker

    exit(g_errors().exit_code());
}
