//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <vector>
#include <cstdint>

class AST;

class CodeGenerator {
public:
    CodeGenerator();
    std::vector<uint8_t> generate(const AST& ast);
};
