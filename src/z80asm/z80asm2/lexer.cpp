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
    while (true) {
        if (!output_queue_.empty()) {
            token_line = std::move(output_queue_.front());
            output_queue_.pop_front();
            if (token_line.tokens().empty()) {
                continue;
            }

            g_errors.set_location(token_line.location());
            g_errors.set_expanded_line(token_line.to_string());

            return true;
        }

        token_line.clear();
        while (token_line.tokens().empty()) {
            // read next source line
            if (!next_line(source_line_)) {
                return false;
            }

            // tokenize the line; may retrieve more lines if there are continuations
            if (!tokenize_line(token_line)) {
                continue;   // no tokens produced due to error
            }

            if (token_line.tokens().empty()) {
                continue;   // skip empty lines
            }

            // split lines at backslashes and colons
            token_line.set_location(Location(filename_, line_number_));
            split_lines(token_line);
            break;
        }
    }
    return true;
}

void TokenFileReader::split_lines(const TokenLine& input_line) {
    TokenLine current_line(input_line.location());
    bool seen_first_token = false;
    bool prev_was_first_ident = false;
    bool prev_was_first_dot = false;
    bool prev_was_instruction = false;
    int ternary_level = 0;  // Track nesting level of ternary operators

    for (size_t i = 0; i < input_line.tokens().size(); ++i) {
        const Token& token = input_line.tokens()[i];

        switch (token.type()) {
        case TokenType::Dot:
            if (!seen_first_token) {
                // First token is dot - this is a label marker (alternative to colon)
                // Expecting identifier next
                seen_first_token = true;
                prev_was_first_dot = true;
                current_line.tokens().push_back(token);
            }
            else {
                // Dot in middle of line - regular token
                seen_first_token = true;
                prev_was_first_ident = false;
                prev_was_first_dot = false;
                prev_was_instruction = false;
                current_line.tokens().push_back(token);
            }
            break;

        case TokenType::Identifier:
            if (!seen_first_token) {
                // First token is identifier - could be followed by colon to make a label
                seen_first_token = true;
                prev_was_first_ident = true;
            }
            else if (prev_was_first_dot) {
                // Identifier after first dot - this completes a dot-label
                // Output the label (dot + identifier) alone
                current_line.tokens().push_back(token);
                output_queue_.push_back(current_line);

                // Start fresh for next part of line
                current_line.tokens().clear();
                current_line.set_location(input_line.location());
                seen_first_token = false;
                prev_was_first_ident = false;
                prev_was_first_dot = false;
                prev_was_instruction = false;
                break;  // Important: skip adding token again and instruction check
            }
            else {
                prev_was_first_ident = false;
            }

            // Check if this identifier is an instruction keyword
            prev_was_instruction = (token.keyword() != Keyword::None) &&
                                   keyword_is_instruction(token.keyword());

            current_line.tokens().push_back(token);
            break;

        case TokenType::Question:
            // Question mark increases ternary level
            ternary_level++;
            current_line.tokens().push_back(token);
            seen_first_token = true;
            prev_was_first_ident = false;
            prev_was_first_dot = false;
            prev_was_instruction = false;
            break;

        case TokenType::Colon:
            // Colon decreases ternary level if we're in a ternary expression
            if (ternary_level > 0) {
                ternary_level--;
                current_line.tokens().push_back(token);
                prev_was_instruction = false;
                break;
            }

            // Normal colon handling (only when ternary_level == 0)
            if (prev_was_first_ident) {
                // Label colon - add it to current line and output the label alone
                Token name_token = current_line.tokens().back();
                current_line.tokens().clear();
                current_line.tokens().push_back(
                    Token(TokenType::Dot, ".", false));
                current_line.tokens().push_back(name_token);
                output_queue_.push_back(current_line);

                // Start fresh for next part of line
                current_line.tokens().clear();
                current_line.set_location(input_line.location());
                seen_first_token = false;
                prev_was_first_ident = false;
                prev_was_first_dot = false;
                prev_was_instruction = false;
            }
            else if (prev_was_instruction) {
                // Colon after instruction - keep it, don't split
                current_line.tokens().push_back(token);
                prev_was_instruction = false;
            }
            else {
                // Separator colon - emit current line without the colon
                if (!current_line.tokens().empty()) {
                    output_queue_.push_back(current_line);
                    current_line.tokens().clear();
                    current_line.set_location(input_line.location());
                }
                seen_first_token = false;
                prev_was_first_ident = false;
                prev_was_first_dot = false;
                prev_was_instruction = false;
                ternary_level = 0;  // Reset ternary level on line split
            }
            break;

        case TokenType::Backslash:
            // Always a split point - emit current line without backslash
            if (!current_line.tokens().empty()) {
                output_queue_.push_back(current_line);
                current_line.tokens().clear();
                current_line.set_location(input_line.location());
            }
            seen_first_token = false;
            prev_was_first_ident = false;
            prev_was_first_dot = false;
            prev_was_instruction = false;
            ternary_level = 0;  // Reset ternary level on line split
            break;

        default:
            // Any other token
            seen_first_token = true;
            prev_was_first_ident = false;
            prev_was_first_dot = false;
            prev_was_instruction = false;
            current_line.tokens().push_back(token);
            break;
        }
    }

    // Don't forget the last line
    if (!current_line.tokens().empty()) {
        output_queue_.push_back(current_line);
    }
}

