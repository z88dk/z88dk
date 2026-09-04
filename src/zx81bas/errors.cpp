//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include <iostream>
#include <string>
#include <cstdlib>

static int error_count = 0;

void error(const SourceLoc& loc, const std::string& message) {
    if (!loc.filename.empty()) {
        std::cerr << loc.filename << ":" << loc.line_num << ": error: " << message <<
                  std::endl;
    }
    else {
        std::cerr << "error: " << message << std::endl;
    }
    error_count++;
}

void error(const std::string& message) {
    std::cerr << "error: " << message << std::endl;
    error_count++;
}

int get_error_count() {
    return error_count;
}

[[noreturn]]
void exit_error_status() {
    if (error_count > 0) {
        std::cerr << std::to_string(error_count)
                  << " error" << (error_count > 1 ? "s" : "")
                  << " found" << std::endl;
        exit(EXIT_FAILURE);
    }

    exit(EXIT_SUCCESS);
}
