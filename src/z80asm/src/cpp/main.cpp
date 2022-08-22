//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "args.h"
#include "asm.h"
#include "errors.h"
#include "if.h"
#include "utils.h"
#include <string>
#include <vector>
using namespace std;

int main(int argc, char *argv[]) {
	// parse command line args
	vector<string> args{ argv + 1, argv + argc };
	g_args.parse_args(args);

	// asssemble required files
	if (!g_errors.count()) {		// if no errors in command line parsing 
		for (auto& file : g_args.files()) {
			if (fs::path(file).extension().generic_string() != EXT_O) {
#if 0
				g_asm.assemble(file);
				g_errors.reset_count();	// so that legacy code assembles files
#endif
			}
		}
	}
	// continue with the legacy code
	return z80asm_main();
}
