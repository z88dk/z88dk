//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "if.h"
#include "options.h"
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
	g_options.parse_args(args);

	return z80asm_main();
}
