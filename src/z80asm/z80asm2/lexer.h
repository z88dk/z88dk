//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <iostream>
#include <string>
#include <vector>

class Token;

#define X(id, text) id,
enum class Keyword {
    None = 0,
#include "keywords.def"
};
#undef X

// macro tokens
enum class MacroTokenType {
    Identifier,
    Number,
    StringLiteral,
    CharLiteral,
    Operator,
    Punctuator,
};

struct MacroToken {
    MacroTokenType type;
    std::string text;
};

// Convert string to upper case
std::string to_upper(const std::string& s);

// trim whitspace at the beginnint and at the end
std::string ltrim(const std::string& s);
std::string rtrim(const std::string& s);

// Convert string to Keyword enum, returns Keyword::None if not found
Keyword to_keyword(const std::string& s);

// Returns true and sets 'out' if a valid C identifier is read from the stream.
// Leaves the stream at the next character after the identifier.
bool scan_identifier(std::istream& is, std::string& out);

// tokenize the macro body into a list of MacroToken
std::vector<MacroToken> tokenize_macro_body(const std::string& body);

class Lexer {
public:
    Lexer();
    void reset(const std::string& input);
    Token next_token();
};
