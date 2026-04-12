//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "diag.h"
#include "lexer_keywords.h"
#include "lexer_tokens.h"
#include "source_loc.h"
#include "string_interner.h"
#include "string_utils.h"
#include <string>
#include <string_view>

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

LogicalLine::LogicalLine(const SourceLoc& loc_, LineOrigin origin_)
    : loc(loc_), origin(origin_) {
}

ParseLine::ParseLine(const std::vector<Token>& tokens_)
    : tokens(tokens_), pos(0) {
}

const Token& ParseLine::peek(size_t offset) const {
    if (pos + offset < tokens.size()) {
        return tokens[pos + offset];
    }

    static Token eof_token =
        Token::end_of_line(tokens.empty() ?
                           SourceLoc() : tokens.back().loc);
    return eof_token;
}

void ParseLine::error(std::string_view message) const {
    g_diag.error(peek().loc, message);
}
