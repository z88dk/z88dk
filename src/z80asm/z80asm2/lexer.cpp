//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "lexer.h"
#include "utils.h"

Token::Token(TokenType type, const std::string& text)
    : type_(type), text_(text) {
    if (type == TokenType::Identifier) {
        keyword_ = keyword_lookup(text);
    }
}

Token::Token(TokenType type, const std::string& text, int value)
    : type_(type), text_(text), int_value_(value) {
}

Token::Token(TokenType type, const std::string& text, double value)
    : type_(type), text_(text), float_value_(value) {
}

Token::Token(TokenType type, const std::string& text, std::string value)
    : type_(type), text_(text), string_value_(value) {
}

Token::Token(TokenType type, const std::string& text, Keyword keyword)
    : type_(type), text_(text), keyword_(keyword) {
}

Token::Token(TokenType type, const std::string& text, OperatorType op)
    : type_(type), text_(text), op_(op) {
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

bool Token::is(OperatorType op) const {
    return op_ == op;
}

bool Token::is_not(OperatorType op) const {
    return op_ != op;
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

OperatorType Token::op() const {
    return op_;
}

Keyword Token::keyword() const {
    return keyword_;
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
        static Token empty_token(TokenType::EndOfFile, "");
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
std::string TokensLine::to_string() const {
    std::string out;
    out.reserve(tokens_.size() * 4);
    for (const auto& tok : tokens_) {
        out += tok.text();
    }
    return out;
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
        g_errors.error(ErrorCode::FileNotFound,
                       "Could not read file: " + filename_);
        content.clear();
    }

    tokenize(content);
}

TokensFile::TokensFile(const std::string& content,
                       const std::string& filename, int first_line_num) :
    filename_(filename),
    first_line_num_(first_line_num),
    inc_line_nums_(false) {
    tokenize(content);
}

void TokensFile::clear() {
    filename_.clear();
    first_line_num_ = 1;
    inc_line_nums_ = true;
    text_lines_.clear();
    tok_lines_.clear();
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

