//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "if.h"
#include "args.h"
#include <string>
#include <vector>
using namespace std;

int main(int argc, char *argv[]) {
	vector<string> args{ argv + 1, argv + argc };
	g_args.parse_args(args);

	return z80asm_main();
}
