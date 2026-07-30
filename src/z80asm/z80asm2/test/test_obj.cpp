//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include <vector>
#include <string>
#include <iostream>

void test_obj_wb_001(const std::vector<std::string>& args) {
    if (args.size() != 1) {
        std::cerr << "Usage: test_obj_wb_001 <obj_file>" << std::endl;
        return;
    }
}
