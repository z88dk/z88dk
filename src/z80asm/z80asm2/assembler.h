//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "errors.h"
#include "preprocessor.h"
#include "symbol_table.h"
#include <cstdint>
#include <string>
#include <vector>

class Lexer;
class Parser;
class CodeGenerator;

class Assembler {
public:
    Assembler();
    void assemble(const std::string& input);
    std::vector<uint8_t> get_output() const;

    // Expose the preprocessor for other users of Assembler if needed.
    Preprocessor& preprocessor() {
        return preprocessor_;
    }

private:
    // Components used by the assembler. Minimal placeholders here so the
    // assembler can register the evaluation callback for the preprocessor.
    Preprocessor preprocessor_;
    SymbolTable symbols_;
};
