//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "lexer.h"
#include "token.h"

Lexer::Lexer() {
    // Stub: to be implemented
}

void Lexer::reset(const std::string& /*input*/) {
    // Stub: to be implemented
}

Token Lexer::nextToken() {
    // Stub: to be implemented
    return Token(TokenType::EndOfFile, "");
}
