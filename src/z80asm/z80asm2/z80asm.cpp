//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "source.h"
#include "utils.h"
#include <iostream>

int main(int argc, char* argv[]) {
    if (argc == 2) {
        // assemble file
        const char* file = argv[1];
        SourceFile& sf = get_source_file(file);
        std::cout << std::string(sf.file) << " has " << sf.lines.size() << " lines\n";
    }
}
