//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "lexer.h"
#include "token.h"
#include <algorithm>
#include <unordered_map>

std::string to_upper(const std::string& s) {
    std::string result = s;
    std::transform(result.begin(), result.end(), result.begin(), ::toupper);
    return result;
}

#define X(keyword) { #keyword, Keyword::keyword },
Keyword to_keyword(const std::string& s) {
    static const std::unordered_map<std::string, Keyword> keyword_map = {
#include "keywords.def"
    };
    auto it = keyword_map.find(to_upper(s));
    return it != keyword_map.end() ? it->second : Keyword::None;
}
#undef X

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

