//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "keywords.h"
#include "lexer.h"
#include "source.h"
#include "utils.h"
#include <cstring>

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

static void tokenize_line(SourceLine& line, bool& in_multiline_comment) {
    const char* text = line.text;
    size_t pos = 0;
    size_t length = std::strlen(text);
    while (pos < length) {
        char c = text[pos];

        // end of multi-line comment
        if (in_multiline_comment) {
            const char* end = std::strstr(text + pos, "*/");
            if (end != nullptr) {
                // leave pos after '/'
                pos = static_cast<size_t>(end - text) + 2;
                in_multiline_comment = false;
            }
            else {
                // not found in this line
                pos = length;
            }
            continue;
        }

        // skip whitespace
        if (is_space(c)) {
            pos++;
            continue;
        }

        // skip assembly comments
        if (c == ';') {
            break;
        }

        // skip multi-line comments and single-line C++ comments
        if (c == '/' && pos + 1 < length) {
            char next = text[pos + 1];
            if (next == '/') {
                // single-line comment, skip rest of line
                break;
            }
            else if (next == '*') {
                // start of multi-line comment
                in_multiline_comment = true;
                pos += 2;
                continue;
            }
        }

        // define loc for the following token
        /*
        SourceLoc loc = line.loc;
        loc.column = static_cast<int>(pos) + 1;
        */


    }
}

void tokenize(SourceFile& source) {
    bool in_multiline_comment = false;
    for (SourceLine& line : source.lines) {
        tokenize_line(line, in_multiline_comment);
        SourceLoc end_loc = line.loc;
        end_loc.column = static_cast<int>(std::strlen(line.text)) + 1;
        line.tokens.push_back(Token::end_of_line(end_loc));
    }
}
