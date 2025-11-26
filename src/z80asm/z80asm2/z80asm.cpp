//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "options.h"

int main(int argc, char* argv[]) {
    // process command line arguments
    for (int i = 1; i < argc; ++i) {
        if (!g_options.parse_arg(argv[i])) {
            exit_invalid_option(argv[i]);
        }
    }

    // detect errors from argument processing
    if (g_errors.has_errors()) {
        return EXIT_FAILURE;
    }

    if (g_options.input_files.empty()) {
        g_errors.error(ErrorCode::NoInputFiles);
        exit(EXIT_FAILURE);
    }

    // execute requested actions
    g_errors.error(ErrorCode::UnknownInstruction,
        "Full assemble not implemented yet");

    return g_errors.has_errors() ? EXIT_FAILURE : EXIT_SUCCESS;
}
