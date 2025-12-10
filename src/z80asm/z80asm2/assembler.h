//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "errors.h"
#include "preprocessor.h"
#include "symbols.h"
#include "unit.h"
#include <cstdint>
#include <string>
#include <vector>
#include <memory>

class Assembler {
public:
    Assembler() = default;
    bool assemble(const std::string& input);
    Preprocessor& preprocessor();
    CompilationUnit& compilation_unit();

private:
    // Components used by the assembler.
    std::unique_ptr<Preprocessor> preprocessor_ = nullptr;
    std::unique_ptr<CompilationUnit> compilation_unit_ = nullptr;
};
