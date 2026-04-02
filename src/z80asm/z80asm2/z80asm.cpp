//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "assembler.h"
#include "errors.h"
#include "options.h"
#include "preprocessor.h"
#include "utils.h"
#include <filesystem>
#include <iostream>
#include <sstream>

int main(int argc, char* argv[]) {
    // process command line arguments
    for (int i = 1; i < argc; ++i) {
        if (!g_options.parse_arg(argv[i])) {
            g_errors.error(ErrorCode::InvalidOption, argv[i]);
        }
    }

    // detect errors from argument processing
    if (g_errors.has_errors()) {
        return EXIT_FAILURE;
    }

    if (g_options.input_files.empty()) {
        g_errors.error(ErrorCode::NoInputFiles);
        return EXIT_FAILURE;
    }

    // execute requested actions
    if (g_options.preprocess_only) {
        preprocess_only();
    }
    else {
        assemble_files();
    }

    return g_errors.has_errors() ? EXIT_FAILURE : EXIT_SUCCESS;
}

