//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include <iostream>
#include "error_reporter.h"
#include "preprocessor.h"

ErrorReporter error_reporter;

int main() {
    Preprocessor pp(error_reporter);
    if (!pp.open("main.asm")) {
        exit(EXIT_FAILURE);
    }
    std::string line;
    Location loc;
    while (pp.next_line(line, loc)) {
        // Pass line and loc to assembler
        std::cout << loc.filename() << ":" << loc.line_num() << ": "
                  << line << std::endl;
    }
}
