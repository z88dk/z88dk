//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "token.h"

Token::Token(TokenType type, const std::string& value)
    : type_(type), value_(value) {
}

TokenType Token::type() const {
    return type_;
}

const std::string& Token::value() const {
    return value_;
}
