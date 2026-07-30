//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include <iostream>
#include <string>
#include <vector>

void test_template(const std::vector<std::string>& args) {
    std::cout << "test_template";
    for (auto& arg : args) {
        std::cout << " " << arg;
    }
    std::cout << std::endl;
}
