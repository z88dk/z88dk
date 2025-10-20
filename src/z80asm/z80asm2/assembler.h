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

    // Callback invoked by Preprocessor when it cannot evaluate a constant
    // expression locally and asks the assembler to try. Implemented in
    // assembler.cpp.
    Preprocessor::EvalResult eval_for_preproc(const std::string& expr,
            const Location& loc);

    // other components (lexer, parser, codegen, ...) can be added later
};
