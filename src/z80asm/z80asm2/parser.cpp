//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast.h"
#include "errors.h"
#include "parser.h"
#include "unit.h"

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
    exprs_.clear();
    const auto& tokens = line_->tokens();

    // check for empty line
    if (i_ >= tokens.size()) {
        return true;
    }

    // check for label
    // preprocessor has already split labels from rest of line
    if (tokens.size() >= 2 &&
            tokens[0].is(TokenType::Dot) &&
            tokens[1].is(TokenType::Identifier)) {
        const std::string label_name = tokens[1].text();
        i_ += 2;
        expect_end();

        // handle label
        unit_->current_module()->add_label_symbol(
            label_name, line_->location(), 0);
        return true;
    }

    expect_end();

    return false;
}

void Parser::expect_end() {
    if (i_ < line_->tokens().size()) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Unexpected token: '" + line_->tokens()[i_].text() + "'");
    }
}
