//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>

class Token;

#define X(keyword) keyword,
enum class Keyword {
    None = 0,
#include "keywords.def"
};
#undef X

std::string to_upper(const std::string& s);
Keyword to_keyword(const std::string& s);

class Lexer {
public:
    Lexer();
    void reset(const std::string& input);
    Token nextToken();
};
