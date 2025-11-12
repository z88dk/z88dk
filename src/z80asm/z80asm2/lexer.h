//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "keywords.h"
#include "location.h"
#include <iostream>
#include <string>
#include <vector>

enum class TokenType {
    EndOfFile,
    Identifier,
    Integer,
    Float,
    String,
    Backslash,
    Comma,
    Dot,
    LeftParen,
    RightParen,
    LeftBracket,
    RightBracket,
    LeftBrace,
    RightBrace,
    Whitespace,
    Power,
    UnaryPlus,
    UnaryMinus,
    LogicalNot,
    BitwiseNot,
    Multiply,
    Divide,
    Modulus,
    Plus,
    Minus,
    ShiftLeft,
    ShiftRight,
    LT,
    LE,
    GT,
    GE,
    EQ,
    NE,
    LogicalAnd,
    BitwiseAnd,
    LogicalOr,
    BitwiseOr,
    LogicalXor,
    BitwiseXor,
    Quest,
    Colon,
    Hash,
    DoubleHash,
    At,
    Dollar,
};

class Token {
public:
    Token(TokenType type, const std::string& text);
    explicit Token(TokenType type, const std::string& text, int value);
    explicit Token(TokenType type, const std::string& text, double value);
    explicit Token(TokenType type, const std::string& text, std::string value);
    explicit Token(TokenType type, const std::string& text, Keyword keyword);

    bool is(TokenType t) const;
    bool is_not(TokenType t) const;
    bool is(Keyword kw) const;
    bool is_not(Keyword kw) const;

    // Read-only accessors
    TokenType type() const;
    const std::string& text() const;
    int int_value() const;
    double float_value() const;
    const std::string& string_value() const;
    Keyword keyword() const;

private:
    TokenType type_;
    std::string text_;            // Original token string
    int int_value_ = 0;           // Used if type == Integer
    double float_value_ = 0.0;    // Used if type == Float
    std::string string_value_;    // Used if type == String (escape-resolved)
    Keyword keyword_ = Keyword::None; // Used if type == Identifier and is a keyword
};

class TokensLine {
public:
    TokensLine() = default;
    TokensLine(const Location& location);
    TokensLine(const Location& location, const std::vector<Token>& tokens);

    void clear();
    void clear_tokens();
    bool empty() const;
    const Location& location() const;
    void set_location(const Location& location);
    void push_back(const Token& token);
    void push_back(Token&& token);
    void pop_back();
    const Token& back() const;
    const Token& operator[](unsigned index) const;
    const std::vector<Token>& tokens() const;
    unsigned size() const;
    std::string to_string() const;
    void skip_spaces(unsigned& i) const;
    bool at_end(unsigned& i) const;
    bool trim();
    void reserve(size_t capacity); // reserve storage in tokens_ vector
    bool has_token_type(TokenType tt) const; // check if any token matches type

private:
    Location location_;             // Location of this line
    std::vector<Token> tokens_;     // Tokens found in this line
};

class TokensFile {
public:
    TokensFile() = default;

    // read a text file
    TokensFile(const std::string& filename,
               int first_line_num = 1);

    // virtual file from a string content
    TokensFile(const std::string& content,
               const std::string& filename,
               int first_line_num, bool inc_line_nums);

    // virtual file directly from pre-tokenized lines (no tokenize())
    TokensFile(const std::vector<TokensLine>& tok_lines,
               const std::string& filename,
               int first_line_num, bool inc_line_nums);

    void clear();
    const std::string& filename() const;
    int first_line_num() const;
    bool inc_line_nums() const;
    unsigned line_count() const;
    const std::string& get_line(unsigned index) const;
    unsigned tok_lines_count() const;
    const TokensLine& get_tok_line(unsigned index) const;
    const std::vector<std::string> text_lines() const;
    const std::vector<TokensLine> tok_lines() const;

    // PRAGMA ONCE support
    bool has_pragma_once() const;
    void set_has_pragma_once(bool v = true);

    // IFNDEF/DEFINE guard support
    bool has_ifndef_guard() const;
    void set_has_ifndef_guard(bool v = true);
    const std::string& ifndef_guard_symbol() const;
    void set_ifndef_guard_symbol(const std::string& symbol);

private:
    std::string filename_;
    int first_line_num_ = 1;
    bool inc_line_nums_ = true;
    std::vector<std::string> text_lines_;
    std::vector<TokensLine> tok_lines_;
    // set true when PRAGMA ONCE seen in this file
    bool has_pragma_once_ = false;
    // set true when IFNDEF/DEFINE guard seen in this file
    bool has_ifndef_guard_ = false;
    std::string ifndef_guard_symbol_;

    void split_lines(const char*& p);
    void tokenize(const std::string& content);
    void tokenize_line(unsigned& line_index, TokensLine& output);
};

