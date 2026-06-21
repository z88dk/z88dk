//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "diag.h"
#include "lexer_keywords.h"
#include "lexer_scan.h"
#include "lexer_tokens.h"
#include "source_loc.h"
#include "string_interner.h"
#include "string_utils.h"
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <string_view>

std::string to_string(TokenType token_type) {
    static const std::string_view lut[] = {
#define X(id, text) text,
#include "lexer_tokens.def"
    };
    return std::string(lut[static_cast<size_t>(token_type)]);
}

std::string make_ident(const std::string& text) {
    if (text.empty()) {
        return "_";
    }

    std::string ident = text;
    if (!is_ident_start(ident[0])) {
        ident[0] = '_';
    }
    for (auto& c : ident) {
        if (!is_ident_char(c)) {
            c = '_';
        }
    }
    return ident;
}

Token Token::token(TokenType type_, std::string_view text,
                   const SourceLoc& loc) {
    Token t;
    t.type = type_;
    t.text_id = g_strings.intern(text);
    t.loc = loc;
    return t;
}

Token Token::identifier(std::string_view ident, const SourceLoc& loc) {
    Token t;
    t.type = TokenType::Identifier;
    t.keyword = keyword_lookup(ident);
    t.text_id = g_strings.intern(ident);
    t.loc = loc;
    return t;
}

Token Token::local_label(std::string_view ident, size_t at_pos,
                         const SourceLoc& loc) {
    Token t;
    t.type = TokenType::LocalLabel;
    t.text_id = g_strings.intern(ident);
    t.value.label_at_pos = at_pos;
    t.loc = loc;
    return t;
}

Token Token::integer(std::string_view text, int value,
                     const SourceLoc& loc) {
    Token t;
    t.type = TokenType::Integer;
    t.text_id = g_strings.intern(text);
    t.value.int_value = value;
    t.loc = loc;
    return t;
}

Token Token::floating(std::string_view text, double value,
                      const SourceLoc& loc) {
    Token t;
    t.type = TokenType::Float;
    t.text_id = g_strings.intern(text);
    t.value.float_value = value;
    t.loc = loc;
    return t;
}

Token Token::string(std::string_view text, std::string_view value,
                    const SourceLoc& loc) {
    Token t;
    t.type = TokenType::String;
    t.text_id = g_strings.intern(text);
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

bool Token::operator==(const Token& other) const noexcept {
    // Compare type, keyword, and text_id
    if (type != other.type || keyword != other.keyword
            || text_id != other.text_id) {
        return false;
    }

    // Compare union value based on token type
    switch (type) {
    case TokenType::Integer:
        return value.int_value == other.value.int_value;
    case TokenType::Float:
        return value.float_value == other.value.float_value;
    case TokenType::String:
        return value.str_value_id == other.value.str_value_id;
    case TokenType::LocalLabel:
        return value.label_at_pos == other.value.label_at_pos;
    default:
        // For other token types, the union is not used or already compared via text_id
        return true;
    }
}

bool Token::operator!=(const Token& other) const noexcept {
    return !(*this == other);
}

std::string to_string(Token token) {
    switch (token.type) {
    case TokenType::Identifier:
        return g_strings.to_string(token.text_id);
    case TokenType::Integer:
        return int_to_hex(token.value.int_value);
    case TokenType::Float:
        return std::to_string(token.value.float_value);
    case TokenType::String:
        return escape_string(g_strings.view(token.value.str_value_id));
    default:
        return to_string(token.type);
    }
}

std::string to_string(const std::vector<Token>& tokens) {
    auto concat = [](const std::string & s1, const std::string & s2) {
        if (s1.empty() || s2.empty()) {
            return s1 + s2;
        }
        else if (ends_with(s1, "##")) {   // cpp-style concatenation
            return s1.substr(0, s1.length() - 2) + s2;
        }
        else if (is_space(s1.back()) || is_space(s2.front())) {
            return s1 + s2;
        }
        else if (is_ident_char(s1.back()) && is_ident_char(s2.front())) {
            return s1 + " " + s2;
        }
        else if (is_ident_char(s1.back()) &&
                 (s2.front() == '$' || s2.front() == '@' || s2.front() == '%')) {
            return s1 + " " + s2;
        }
        else if (s1.back() == '$' && is_hex_digit(s2.front())) {
            return s1 + " " + s2;
        }
        else if ((s1.back() == '%' || s1.back() == '@') &&
                 (is_dec_digit(s2.front()) || s2.front() == '"' ||
                  is_ident_start(s2.front()))) {
            return s1 + " " + s2;
        }
        else if ((s1.back() == '&' && s2.front() == '&') ||
                 (s1.back() == '|' && s2.front() == '|') ||
                 (s1.back() == '^' && s2.front() == '^') ||
                 (s1.back() == '*' && s2.front() == '*') ||
                 (s1.back() == '<' &&
                  (s2.front() == '=' || s2.front() == '<' || s2.front() == '>')) ||
                 (s1.back() == '>' &&
                  (s2.front() == '=' || s2.front() == '>')) ||
                 (s1.back() == '=' && s2.front() == '=') ||
                 (s1.back() == '!' && s2.front() == '=') ||
                 (s1.back() == '#' && s2.front() == '#')) {
            return s1 + " " + s2;
        }
        else {
            return s1 + s2;
        }
    };

    std::string out;
    for (const Token& token : tokens) {
        out = concat(out, to_string(token));
    }
    return out;
}

LogicalLine::LogicalLine(const SourceLoc& loc_, LineOrigin origin_)
    : loc(loc_), origin(origin_) {
}

ParseLine::ParseLine(const std::vector<Token>& tokens_, size_t pos_)
    : tokens(tokens_), pos(pos_) {
}

const Token& ParseLine::peek(size_t offset) const {
    if (pos + offset < tokens.size()) {
        return tokens[pos + offset];
    }

    // to return a reference when out of bounds
    static Token eol_token = Token::end_of_line(SourceLoc());
    if (tokens.empty()) {
        eol_token.loc = SourceLoc();
    }
    else {
        // point to after last token for better error messages when the expression is exhausted
        eol_token.loc = tokens.back().loc;
        eol_token.loc.column += static_cast<uint16_t>(g_strings.view(
                                    tokens.back().text_id).size());
    }

    return eol_token;
}

void ParseLine::advance() {
    if (pos < tokens.size()) {
        ++pos;
    }
}

bool ParseLine::eol() const {
    return pos >= tokens.size() || peek().type == TokenType::EndOfLine;
}

void ParseLine::error(std::string_view message) const {
    g_diag.error(peek().loc, message);
}

bool ParseLine::check_end_of_line() {
    while (pos < tokens.size() &&
            peek().type == TokenType::EndOfLine) {
        ++pos;
    }

    if (pos < tokens.size()) {
        g_diag.error(peek().loc,
                     "Unexpected token: " +
                     escape_string(g_strings.to_string(peek().text_id)));
        return false;
    }

    return true;
}

std::string ParseLine::prev_token_text() const {
    if (pos > 0 && pos - 1 < tokens.size()) {
        return escape_string(g_strings.view(tokens[pos - 1].text_id));
    }
    return "";
}

