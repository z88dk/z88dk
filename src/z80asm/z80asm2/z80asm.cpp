//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include <iostream>
#include "errors.h"
#include "preprocessor.h"

Errors error_reporter;

int main() {
    Preprocessor pp;
    if (!pp.open("main.asm")) {
        exit(EXIT_FAILURE);
    }
    std::string line;
    while (pp.next_line(line)) {
        // Pass line assembler
        std::cout << g_errors.filename() << ":"
                  << g_errors.line_num() << ": "
                  << line << std::endl;
    }
}
