//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "args.h"
#include "errors.h"
#include "model.h"
#include "stack_trace.h"
#include "xassert.h"
#include "xmalloc.h"
#include <string>
#include <vector>
using namespace std;

int main(int argc, char *argv[]) {
	dump_stack_on_sigsegv();
    xassert_init(argv[0]);
    xmalloc_init(argv[0]);

	vector<string> args{ argv + 1, argv + argc };
	g_args.parse_args(args);
    if (g_errors.count)
        return EXIT_FAILURE;

    // asssemble required files
    if (!g_args.lib_for_all_cpus) {
        for (auto& file : g_args.input_files) {
            if (fs::path(file).extension().generic_string() != EXT_O) {
                g_asm.assemble(file);
            }
            else {
                assemble_file(file.c_str());        // legacy code
            }
        }
    }

    // continue with the legacy code
    return z80asm_linker();
}

