//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "assembler.h"
#include "code_generator.h"
#include "error_reporter.h"
#include "lexer.h"
#include "parser.h"
#include "symbol_table.h"

Assembler::Assembler() {
    // Initialize components as needed
}

void Assembler::assemble(const std::string& /*input*/) {
    // Stub: to be implemented
}

std::vector<uint8_t> Assembler::getOutput() const {
    // Stub: to be implemented
    return {};
}
