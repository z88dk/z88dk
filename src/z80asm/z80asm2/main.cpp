//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "common.h"
#include "files.h"
#include "linker.h"
#include "ofiles.h"
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
    g_options.parse_args(args);
    if (g_errors.count())
        return EXIT_FAILURE;

    // asssemble or load object files
    if (!g_options.lib_for_all_cpus()) {
        for (auto& file : g_options.input_files()) {
            if (file_extension(file) == EXT_OBJ)
                g_asm.load_object(file);
            else
                g_asm.assemble(file);
        }

        if (g_errors.count())
            return EXIT_FAILURE;
    }

    // make library
    if (!g_options.lib_filename().empty()) {
        LibFileWriter lib_writer(g_options.lib_filename());
        lib_writer.write();

        if (g_errors.count())
            return EXIT_FAILURE;
    }
    // make binary
    else if (g_options.make_bin()) {
        xassert(!g_asm.objects().empty());
        string bin_filename = file_bin_filename(g_asm.objects()[0]->obj_filename());

        Linker linker(bin_filename);
        linker.link_library_modules();
        if (g_errors.count())
            return EXIT_FAILURE;

        linker.allocate_addresses();
        if (g_errors.count())
            return EXIT_FAILURE;

        linker.write();
        if (g_errors.count())
            return EXIT_FAILURE;
    }

    return g_errors.exit_code();
}
