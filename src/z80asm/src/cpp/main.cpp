//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2023
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "args.h"
#include "asm.h"
#include "errors.h"
#include "if.h"
#include "utils.h"
#include "xassert.h"
#include <string>
#include <vector>
using namespace std;

int main(int argc, char *argv[]) {
    xassert_init(argv[0]);

	vector<string> args{ argv + 1, argv + argc };
	g_args.parse_args(args);

	// asssemble required files
	if (!g_errors.count()) {		// if no errors in command line parsing
        if (!g_args.lib_for_all_cpus()) {
            for (auto& file : g_args.files()) {
                if (fs::path(file).extension().generic_string() != EXT_O) {
                    g_asm.assemble(file);
                }
                else {
                    assemble_file(file.c_str());        // legacy code
                }
            }
        }
	}

	// continue with the legacy code
	return z80asm_linker();
}

void g_asm_assemble_file(const char* filename) {
    g_asm.assemble(filename);
}
