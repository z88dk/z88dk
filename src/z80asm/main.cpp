//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "if.h"
#include "z80asm.h"

int main(int argc, char* argv[]) {
    dump_stack_on_sigsegv();
    xassert_init(Z80ASM_PROG);

    vector<string> args{ argv + 1, argv + argc };
    g_args.parse(Z80ASM_PROG, args);
    if (g_errors.count)
        exit(EXIT_FAILURE);

#if 0
    for (auto& file : g_args.files)
        g_asm.assemble(file);
#endif

    return z80asm_main();
}
