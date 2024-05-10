//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "common.h"
#include "stack_trace.h"
#include "xassert.h"
#include <iostream>
using namespace std;

int main(int argc, char* argv[]) {
    dump_stack_on_sigsegv();
    xassert_init(argv[0]);

    vector<string> args{ argv + 1, argv + argc };
    g_asm.options().parse_args(args);

    exit(g_asm.exit_code());
}
