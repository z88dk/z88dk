//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>

enum class TokenType {
    Identifier,
    Number,
    Operator,
    EndOfFile
};

class Token {
public:
    Token(TokenType type, const std::string& value);
    TokenType type() const;
    const std::string& value() const;
private:
    TokenType type_;
    std::string value_;
};
