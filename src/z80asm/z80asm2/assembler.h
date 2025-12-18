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
    void assemble(const std::string& input_filename);

private:
    std::string input_filename_;
    Preprocessor preprocessor_;
    CompilationUnit compilation_unit_;
};

void assemble_files();
