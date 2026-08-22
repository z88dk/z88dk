//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include <iostream>
#include <string>

static int error_count = 0;

void error(const std::string& filename, int line, const std::string& message) {
    if (!filename.empty()) {
        std::cerr << filename << ":" << line << ": error: " << message << std::endl;
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
