//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "parser.h"
#include "ast.h"

Parser::Parser(CompilationUnit* unit)
    : unit_(unit) {
}

void Parser::clear() {
    line_ = nullptr;
    i_ = 0;
    exprs_.clear();
}

bool Parser::parse(const TokenLine& line) {
    line_ = &line;
    i_ = 0;

    // check for empty line
    if (i_ >= line_->tokens().size()) {
        return true;
    }

    return false;
}
