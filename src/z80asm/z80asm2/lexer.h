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
    Operator,
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
};

enum class OperatorType {
    None,
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
    Ternary,
    Hash,
    DoubleHash,
};

class Token {
public:
    Token(TokenType type, const std::string& text);
    explicit Token(TokenType type, const std::string& text, int value);
    explicit Token(TokenType type, const std::string& text, double value);
    explicit Token(TokenType type, const std::string& text, std::string value);
    explicit Token(TokenType type, const std::string& text, Keyword keyword);
    explicit Token(TokenType type, const std::string& text, OperatorType op);

    bool is(TokenType t) const;
    bool is_not(TokenType t) const;
    bool is(Keyword kw) const;
    bool is_not(Keyword kw) const;
    bool is(OperatorType op) const;
    bool is_not(OperatorType op) const;

    // Read-only accessors
    TokenType type() const;
    const std::string& text() const;
    int int_value() const;
    double float_value() const;
    const std::string& string_value() const;
    OperatorType op() const;
    Keyword keyword() const;

private:
    TokenType type_;
    std::string text_;            // Original token string
    int int_value_ = 0;           // Used if type == Integer
    double float_value_ = 0.0;    // Used if type == Float
    std::string string_value_;    // Used if type == String (escape-resolved)
    OperatorType op_ = OperatorType::None; // Used if type == Operator
    Keyword keyword_ = Keyword::None; // Used if type == Identifier and is a keyword
};

class TokensLine {
public:
    TokensLine() = default;
    TokensLine(const Location& location);
    TokensLine(const Location& location, const std::vector<Token>& tokens);

    void clear();
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
               int first_line_num);

    void clear();
    const std::string& filename() const;
    int first_line_num() const;
    bool inc_line_nums() const;
    unsigned line_count() const;
    const std::string& get_line(unsigned index) const;
    unsigned tok_lines_count() const;
    const TokensLine& get_tok_line(unsigned index) const;

private:
    std::string filename_;                  // Source file name
    int first_line_num_ = 1;                // Initial line number
    bool inc_line_nums_ = true;             // Whether to increment line numbers
    std::vector<std::string> text_lines_;   // input text lines
    std::vector<TokensLine> tok_lines_;     // All not-empty tokenized lines

    void split_lines(const char*& p);
    void tokenize(const std::string& content);
    void tokenize_line(unsigned& line_index, TokensLine& output);
};

