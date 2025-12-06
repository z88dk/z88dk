//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "lexer.h"
#include "utils.h"
#include <algorithm>

//-----------------------------------------------------------------------------
// Token implementation
//-----------------------------------------------------------------------------

Token::Token(TokenType type, const std::string& text, bool has_space_after)
    : type_(type), text_(text), has_space_after_(has_space_after) {
    switch (type) {
    case TokenType::Identifier:
        keyword_ = keyword_lookup(text);
        break;
    case TokenType::Integer: {
        size_t pos = 0;
        int_value_ = std::stoi(text, &pos);
        if (pos != text.size()) {
            throw std::invalid_argument("Trailing chars in integer: " + text);
        }
        break;
    }
    case TokenType::Float: {
        size_t pos = 0;
        float_value_ = std::stod(text, &pos);
        if (pos != text.size()) {
            throw std::invalid_argument("Trailing chars in float: " + text);
        }
        break;
    }
    case TokenType::String:
        string_value_ = unescape_c_string(text);
        break;
    default:
        ;
    }
}

Token::Token(TokenType type, const std::string& text,
             int value, bool has_space_after)
    : type_(type), text_(text)
    , int_value_(value), has_space_after_(has_space_after) {
}

Token::Token(TokenType type, const std::string& text,
             double value, bool has_space_after)
    : type_(type), text_(text)
    , float_value_(value), has_space_after_(has_space_after) {
}

Token::Token(TokenType type, const std::string& text,
             std::string value, bool has_space_after)
    : type_(type), text_(text)
    , string_value_(value), has_space_after_(has_space_after) {
}

Token::Token(TokenType type, const std::string& text,
             Keyword keyword, bool has_space_after)
    : type_(type), text_(text)
    , keyword_(keyword), has_space_after_(has_space_after) {
}

bool Token::is(TokenType t) const {
    return type_ == t;
}

bool Token::is(Keyword kw) const {
    return keyword_ == kw;
}

// Read-only accessors
TokenType Token::type() const {
    return type_;
}

const std::string& Token::text() const {
    return text_;
}

int Token::int_value() const {
    return int_value_;
}

double Token::float_value() const {
    return float_value_;
}

const std::string& Token::string_value() const {
    return string_value_;
}

Keyword Token::keyword() const {
    return keyword_;
}

bool Token::has_space_after() const {
    return has_space_after_;
}

//-----------------------------------------------------------------------------
// TokenLine implementation
//-----------------------------------------------------------------------------

TokenLine::TokenLine(const Location& location)
    : location_(location) {
}

TokenLine::TokenLine(const Location& location,
                     const std::vector<Token>& tokens)
    : location_(location), tokens_(tokens) {
}

void TokenLine::clear() {
    location_.clear();
    tokens_.clear();
}

const Location& TokenLine::location() const {
    return location_;
}

void TokenLine::set_location(const Location& location) {
    location_ = location;
}

std::vector<Token>& TokenLine::tokens() {
    return tokens_;
}

const std::vector<Token>& TokenLine::tokens() const {
    return tokens_;
}

bool TokenLine::has_token_type(TokenType tt) const {
    for (const auto& t : tokens_) {
        if (t.is(tt)) {
            return true;
        }
    }
    return false;
}

// Reconstruct the line by concatenating the original token texts in order.
// Insert spaces where necessary to avoid accidental re-scanning into different tokens:
//  - always insert a space between Identifier, Integer and Float tokens when adjacent
//  - insert a space between tokens whose concatenation would form a multi-character operator
std::string TokenLine::to_string() const {
    std::string out;
    out.reserve(tokens_.size() * 4);

    // list of multi-character operator strings that must not be produced by direct concatenation
    static const std::vector<std::string> problematic = {
        "<<", ">>", "<=", ">=", "==", "!=", "<>",
        "&&", "||", "^^", "**", "##"
    };

    auto is_idnum = [](TokenType t) {
        return t == TokenType::Identifier || t == TokenType::Integer ||
               t == TokenType::Float;
    };

    for (unsigned i = 0; i < tokens_.size(); ++i) {
        const auto& tok = tokens_[i];
        char last_char = out.empty() ? ' ' : out.back();
        char first_char = tok.text().empty() ? ' ' : tok.text().front();

        if (i > 0 && last_char != ' ') {
            const auto& prev = tokens_[i - 1];

            bool need_space = false;
            if (is_idnum(prev.type()) && is_idnum(tok.type())) {
                need_space = true;
            }
            else if (prev.type() == TokenType::Dollar && is_hex_char(first_char)) {
                // $ followed by hex digit could be part of a hex number
                need_space = true;
            }
            else if ((prev.type() == TokenType::Modulo || prev.type() == TokenType::At) &&
                     is_bin_char(first_char)) {
                // % followed by number could be part of a binary number
                need_space = true;
            }
            else {
                std::string concat = prev.text() + tok.text();
                if (std::find(problematic.begin(), problematic.end(),
                              concat) != problematic.end()) {
                    need_space = true;
                }
            }

            if (need_space) {
                out += ' ';
            }
        }

        switch (tok.type()) {
        case TokenType::Integer:
            out += std::to_string(tok.int_value());
            break;
        default:
            out += tok.text();
            break;
        }

        last_char = out.empty() ? ' ' : out.back();
        if (last_char != ' ' && tok.has_space_after()) {
            out += ' ';
        }
    }

    return trim(out);
}

//-----------------------------------------------------------------------------
// TokenFileReader implementation
//-----------------------------------------------------------------------------

TokenFileReader::TokenFileReader(const std::string& filename)
    : FileReader(filename) {
}

bool TokenFileReader::next_token_line(TokenLine& token_line) {
    token_line.clear();

    while (token_line.tokens().empty()) {
        // read next source line
        if (!next_line(source_line_)) {
            return false;
        }

        // tokenize the line; may retrieve more lines if there are continuations
        if (tokenize_line(token_line) && !token_line.tokens().empty()) {
            break;
        }
    }

    token_line.set_location(Location(filename_, line_number_));
    g_errors.set_expanded_line(token_line.to_string());
    return true;
}
