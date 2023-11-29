//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2023
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "args.h"
#include "if.h"
#include "xassert.h"
#include <string>
#include <vector>
using namespace std;

int main(int argc, char *argv[]) {
    xassert_init(argv[0]);

	vector<string> args{ argv + 1, argv + argc };
	g_args.parse_args(args);

	return z80asm_main();
}
