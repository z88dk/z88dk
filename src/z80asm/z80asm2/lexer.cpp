//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "lexer.h"
#include "utils.h"
#include <algorithm>

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

bool Token::is_not(TokenType t) const {
    return type_ != t;
}

bool Token::is(Keyword kw) const {
    return keyword_ == kw;
}

bool Token::is_not(Keyword kw) const {
    return keyword_ != kw;
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

TokensLine::TokensLine(const Location& location)
    : location_(location) {
}

TokensLine::TokensLine(const Location& location,
                       const std::vector<Token>& tokens)
    : location_(location), tokens_(tokens) {
}

void TokensLine::clear() {
    location_.clear();
    tokens_.clear();
}

void TokensLine::clear_tokens() {
    tokens_.clear();
}

bool TokensLine::empty() const {
    return tokens_.empty();
}

const Location& TokensLine::location() const {
    return location_;
}

void TokensLine::set_location(const Location& location) {
    location_ = location;
}

void TokensLine::push_back(const Token& token) {
    tokens_.push_back(token);
}

void TokensLine::push_back(Token&& token) {
    tokens_.push_back(std::move(token));
}

void TokensLine::pop_back() {
    tokens_.pop_back();
}

const Token& TokensLine::back() const {
    return tokens_.back();
}

const Token& TokensLine::operator[](unsigned index) const {
    if (index >= tokens_.size()) {
        static Token empty_token(TokenType::EndOfLine, "", false);
        return empty_token;
    }
    else {
        return tokens_[index];
    }
}

const std::vector<Token>& TokensLine::tokens() const {
    return tokens_;
}

unsigned TokensLine::size() const {
    return static_cast<unsigned>(tokens_.size());
}

// Reconstruct the line by concatenating the original token texts in order.
// Insert spaces where necessary to avoid accidental re-scanning into different tokens:
//  - always insert a space between Identifier, Integer and Float tokens when adjacent
//  - insert a space between tokens whose concatenation would form a multi-character operator
std::string TokensLine::to_string() const {
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

    auto is_prefix = [](TokenType t) {
        return t == TokenType::Dollar || t == TokenType::Modulus ||
               t == TokenType::At;
    };

    for (unsigned i = 0; i < tokens_.size(); ++i) {
        const auto& tok = tokens_[i];
        char last_char = out.empty() ? ' ' : out.back();

        if (i > 0 && last_char != ' ') {
            const auto& prev = tokens_[i - 1];

            bool need_space = false;
            if (is_idnum(prev.type()) && is_idnum(tok.type())) {
                need_space = true;
            }
            else if (is_prefix(prev.type()) && is_idnum(tok.type())) {
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

bool TokensLine::at_end(unsigned i) const {
    return i >= size();
}

void TokensLine::reserve(size_t capacity) {
    tokens_.reserve(capacity);
}

bool TokensLine::has_token_type(TokenType tt) const {
    for (const auto& t : tokens_) {
        if (t.is(tt)) {
            return true;
        }
    }
    return false;
}

//-----------------------------------------------------------------------------

TokensFile::TokensFile(const std::string& filename,
                       int first_line_num) :
    filename_(filename),
    first_line_num_(first_line_num),
    inc_line_nums_(true) {
    std::string content;
    try {
        content = read_file_to_string(filename);
    }
    catch (...) {
        // file read error
        g_errors.error(ErrorCode::FileNotFound, filename_);
        content.clear();
    }

    tokenize(content);
}

TokensFile::TokensFile(const std::string& content,
                       const std::string& filename,
                       int first_line_num, bool inc_line_nums) :
    filename_(filename),
    first_line_num_(first_line_num),
    inc_line_nums_(inc_line_nums) {
    tokenize(content);
}

TokensFile::TokensFile(const std::vector<TokensLine>& tok_lines,
                       const std::string& filename,
                       int first_line_num, bool inc_line_nums)
    : filename_(filename),
      first_line_num_(first_line_num),
      inc_line_nums_(inc_line_nums),
      tok_lines_(tok_lines) {
}

void TokensFile::clear() {
    filename_.clear();
    first_line_num_ = 1;
    inc_line_nums_ = true;
    text_lines_.clear();
    tok_lines_.clear();
    has_pragma_once_ = false;
}

const std::string& TokensFile::filename() const {
    return filename_;
}

int TokensFile::first_line_num() const {
    return first_line_num_;
}

bool TokensFile::inc_line_nums() const {
    return inc_line_nums_;
}

unsigned TokensFile::line_count() const {
    return static_cast<unsigned>(text_lines_.size());
}

const std::string& TokensFile::get_line(unsigned index) const {
    if (index >= text_lines_.size()) {
        static std::string empty;
        return empty;
    }
    else {
        return text_lines_[index];
    }
}

unsigned TokensFile::tok_lines_count() const {
    return static_cast<unsigned>(tok_lines_.size());
}

const TokensLine& TokensFile::get_tok_line(unsigned index) const {
    if (index >= tok_lines_.size()) {
        static TokensLine empty_line;
        return empty_line;
    }
    else {
        return tok_lines_[index];
    }
}

const std::vector<std::string> TokensFile::text_lines() const {
    return text_lines_;
}

const std::vector<TokensLine> TokensFile::tok_lines() const {
    return tok_lines_;
}

// PRAGMA ONCE support
bool TokensFile::has_pragma_once() const {
    return has_pragma_once_;
}

void TokensFile::set_has_pragma_once(bool v) {
    has_pragma_once_ = v;
}

bool TokensFile::has_ifndef_guard() const {
    return has_ifndef_guard_;
}

void TokensFile::set_has_ifndef_guard(bool v) {
    has_ifndef_guard_ = v;
}

const std::string& TokensFile::ifndef_guard_symbol() const {
    return ifndef_guard_symbol_;
}

void TokensFile::set_ifndef_guard_symbol(const std::string& symbol) {
    ifndef_guard_symbol_ = symbol;
}

void TokensFile::split_lines(const char*& p) {
    text_lines_.clear();
    while (*p) {
        const char* line_start = p;
        while (*p && *p != '\r' && *p != '\n') {
            ++p;
        }
        text_lines_.emplace_back(line_start, p - line_start);
        // Handle line endings
        if (*p == '\r') {
            ++p;
            if (*p == '\n') {
                ++p;
            }
        }
        else if (*p == '\n') {
            ++p;
        }
    }
}

void TokensFile::tokenize(const std::string& content) {
    // Split content into lines
    const char* p = content.c_str();
    split_lines(p);

    // Tokenize each line
    Location location(filename_, first_line_num_);
    for (unsigned i = 0; i < text_lines_.size(); ++i) {
        // notify error reporter of current line
        int line_num = first_line_num_ + (inc_line_nums_ ? i : 0);
        location.set_line_num(line_num);
        g_errors.set_location(location);
        g_errors.set_source_line(text_lines_[i]);

        // split in tokens, possibly advancing i for line continuations
        // and multi-line comments
        TokensLine tok_line(location);
        tokenize_line(i, tok_line);
        if (!tok_line.empty()) {
            tok_lines_.push_back(std::move(tok_line));
        }
    }
}
