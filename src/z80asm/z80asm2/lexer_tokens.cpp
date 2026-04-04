//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "lexer_tokens.h"

Token Token::token(TokenType type_, std::string_view text_,
                   const SourceLoc& loc) {
    Token t;
    t.type = type_;
    t.text_id = g_strings.intern(text_);
    t.loc = loc;
    return t;
}

Token Token::identifier(std::string_view text_,
                        const SourceLoc& loc) {
    Token t;
    t.type = TokenType::Identifier;
    t.keyword = keyword_lookup(text_);
    t.text_id = g_strings.intern(text_);
    t.loc = loc;
    return t;
}

Token Token::integer(std::string_view text_, int value,
                     const SourceLoc& loc) {
    Token t;
    t.type = TokenType::Integer;
    t.text_id = g_strings.intern(text_);
    t.value.int_value = value;
    t.loc = loc;
    return t;
}

Token Token::floating(std::string_view text_, double value,
                      const SourceLoc& loc) {
    Token t;
    t.type = TokenType::Float;
    t.text_id = g_strings.intern(text_);
    t.value.float_value = value;
    t.loc = loc;
    return t;
}

Token Token::string(std::string_view text_, std::string_view value,
                    const SourceLoc& loc) {
    Token t;
    t.type = TokenType::String;
    t.text_id = g_strings.intern(text_);
    t.value.str_value_id = g_strings.intern(value);
    t.loc = loc;
    return t;
}

Token Token::end_of_line(const SourceLoc& loc) {
    Token t;
    t.type = TokenType::EndOfLine;
    t.text_id = g_strings.intern("\n");
    t.loc = loc;
    return t;
}

