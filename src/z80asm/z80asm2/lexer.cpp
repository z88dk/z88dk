//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "lexer.h"
#include "keywords.h"

Token Token::token(TokenType type_, const std::string& text_,
                   const SourceLoc& loc) {
    Token t;
    t.type = type_;
    t.text = strpool(text_);
    t.loc = loc;
    return t;
}

Token Token::identifier(const std::string& text_,
                        const SourceLoc& loc) {
    Token t;
    t.type = TokenType::Identifier;
    t.keyword = keyword_lookup(text_);
    t.text = strpool(text_);
    t.loc = loc;
    return t;
}

Token Token::integer(const std::string& text_, int value,
                     const SourceLoc& loc) {
    Token t;
    t.type = TokenType::Integer;
    t.text = strpool(text_);
    t.int_value = value;
    t.loc = loc;
    return t;
}

Token Token::floating(const std::string& text_, double value,
                      const SourceLoc& loc) {
    Token t;
    t.type = TokenType::Float;
    t.text = strpool(text_);
    t.float_value = value;
    t.loc = loc;
    return t;
}

Token Token::string(const std::string& text_, const std::string& value,
                    const SourceLoc& loc) {
    Token t;
    t.type = TokenType::String;
    t.text = strpool(text_);
    t.str_value = strpool(value);
    t.loc = loc;
    return t;
}

Token Token::end_of_line(const SourceLoc& loc) {
    Token t;
    t.type = TokenType::EndOfLine;
    t.loc = loc;
    return t;
}

Token Token::end_of_file(const SourceLoc& loc) {
    Token t;
    t.type = TokenType::EndOfFile;
    t.loc = loc;
    return t;
}
