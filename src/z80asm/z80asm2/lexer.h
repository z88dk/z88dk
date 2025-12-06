//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "file_cache.h"
#include "keywords.h"
#include "location.h"
#include <deque>
#include <iostream>
#include <string>
#include <vector>

enum class TokenType {
    EndOfLine,
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
    Power,
    LogicalNot,
    BitwiseNot,
    Multiply,
    Divide,
    Modulo,
    Plus,
    Minus,
    LeftShift,
    RightShift,
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
    Question,
    Colon,
    Hash,
    DoubleHash,
    At,
    Dollar,
    ASMPC,
};

class Token {
public:
    Token(TokenType type, const std::string& text, bool has_space_after);
    explicit Token(TokenType type, const std::string& text,
                   int value, bool has_space_after);
    explicit Token(TokenType type, const std::string& text,
                   double value, bool has_space_after);
    explicit Token(TokenType type, const std::string& text,
                   std::string value, bool has_space_after);
    explicit Token(TokenType type, const std::string& text,
                   Keyword keyword, bool has_space_after);

    bool is(TokenType t) const;
    bool is(Keyword kw) const;

    // Read-only accessors
    TokenType type() const;
    const std::string& text() const;
    int int_value() const;
    double float_value() const;
    const std::string& string_value() const;
    Keyword keyword() const;
    bool has_space_after() const;

private:
    TokenType type_;
    std::string text_;            // Original token string
    int int_value_ = 0;           // Used if type == Integer
    double float_value_ = 0.0;    // Used if type == Float
    std::string string_value_;    // Used if type == String (escape-resolved)
    Keyword keyword_ = Keyword::None; // Used if type == Identifier and is a keyword
    bool has_space_after_ =
        false; // true if original source had space after this token
};

class TokenLine {
public:
    TokenLine() = default;
    TokenLine(const Location& location);
    TokenLine(const Location& location, const std::vector<Token>& tokens);

    void clear();

    const Location& location() const;
    void set_location(const Location& location);

    std::vector<Token>& tokens();
    const std::vector<Token>& tokens() const;
    bool has_token_type(TokenType tt) const; // check if any token matches type

    std::string to_string() const;

private:
    Location location_;             // Location of this line
    std::vector<Token> tokens_;     // Tokens found in this line
};

class TokenFileReader : public FileReader {
public:
    TokenFileReader() = default;
    TokenFileReader(const std::string& filename);

    // Read next line from file and tokenize it
    // Returns true if a line was read, false on EOF
    bool next_token_line(TokenLine& out_line);

private:
    std::deque<TokenLine> output_queue_;
    std::string source_line_; // current source line being tokenized
    bool tokenize_line(TokenLine& out_line);

    void split_lines(const TokenLine& input_line);
};
