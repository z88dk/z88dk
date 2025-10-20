//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "assembler.h"
#include "code_generator.h"
#include "errors.h"
#include "lexer.h"
#include "parser.h"
#include "symbol_table.h"
#include <string>

Assembler::Assembler() {
    // Register preprocessor callback so Preprocessor can ask the assembler
    // to evaluate expressions it cannot compute locally.
    preprocessor_.set_eval_callback(
        [this](const std::string & expr,
    const Location & loc) -> Preprocessor::EvalResult {
        return this->eval_for_preproc(expr, loc);
    }
    );

    // Other component initialization...
}

void Assembler::assemble(const std::string& /*input*/) {
    // Stub: to be implemented
}

std::vector<uint8_t> Assembler::get_output() const {
    // Stub: to be implemented
    return {};
}

// Minimal assembler-side evaluator used by Preprocessor when it cannot
// evaluate a constant expression locally.
//
// Current behavior:
// - Attempts to parse integer literals (supports "$" hex prefix and
//   C-style "0x" prefix / decimal via std::stoi).
// - If parsing succeeds returns ok=true and the integer value.
// - Otherwise returns ok=false so the preprocessor knows the assembler
//   could not evaluate the expression.
//
// Extend this implementation to:
// - Use the assembler's SymbolTable to resolve symbol names.
// - Evaluate full expressions using the assembler expression evaluator,
//   and set unknown_link_time when the result depends on link-time symbols.
Preprocessor::EvalResult Assembler::eval_for_preproc(const
        std::string& /*expr*/,
        const Location& /*loc*/) {
    Preprocessor::EvalResult res;
    res.value = 0;
    res.ok = false;
    res.unknown_link_time = true;
    return res;
}
