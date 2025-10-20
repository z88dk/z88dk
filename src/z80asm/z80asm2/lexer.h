//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "keywords.h"
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
    Token(TokenType type, const std::string& text)
        : type_(type), text_(text) {
    }

    explicit Token(TokenType type, const std::string& text, int value)
        : type_(type), text_(text), int_value_(value) {
    }

    explicit Token(TokenType type, const std::string& text, double value)
        : type_(type), text_(text), float_value_(value) {
    }

    explicit Token(TokenType type, const std::string& text, std::string value)
        : type_(type), text_(text), string_value_(value) {
    }

    explicit Token(TokenType type, const std::string& text, Keyword keyword)
        : type_(type), text_(text), keyword_(keyword) {
    }

    explicit Token(TokenType type, const std::string& text, OperatorType op)
        : type_(type), text_(text), op_(op) {
    }

    bool is(TokenType t) const {
        return type_ == t;
    }

    bool is_not(TokenType t) const {
        return type_ != t;
    }

    bool is(Keyword kw) const {
        return keyword_ == kw;
    }

    bool is_not(Keyword kw) const {
        return keyword_ != kw;
    }

    bool is(OperatorType op) const {
        return op_ == op;
    }

    bool is_not(OperatorType op) const {
        return op_ != op;
    }

    // Read-only accessors
    TokenType type() const {
        return type_;
    }
    const std::string& text() const {
        return text_;
    }
    int int_value() const {
        return int_value_;
    }
    double float_value() const {
        return float_value_;
    }
    const std::string& string_value() const {
        return string_value_;
    }
    OperatorType op() const {
        return op_;
    }
    Keyword keyword() const {
        return keyword_;
    }

private:
    TokenType type_;
    std::string text_;            // Original token string
    int int_value_ = 0;           // Used if type == Integer
    double float_value_ = 0.0;    // Used if type == Float
    std::string string_value_;    // Used if type == String (escape-resolved)
    OperatorType op_ = OperatorType::None; // Used if type == Operator
    Keyword keyword_ = Keyword::None; // Used if type == Identifier and is a keyword
};

class TokenizedLine {
public:
    TokenizedLine(int line_num);

    void clear();
    bool empty() const {
        return tokens_.empty();
    }
    int line_num() const {
        return line_num_;
    }
    auto front() const {
        return tokens_.front();
    }
    auto back() const {
        return tokens_.back();
    }
    void pop_back() {
        tokens_.pop_back();
    }

    void push_back(const Token& token);
    void push_back(Token&& token);
    const Token& peek(int ahead = 0) const;
    void advance();
    void rewind();
    bool at_end() const;
    void skip_spaces();
    std::string to_string() const;

private:
    int line_num_ = 0;              // 1-based line number
    std::vector<Token> tokens_;     // Tokens found in this line
    int cur_index_ = 0;             // Current token index for parsing
};

class TokenizedFile {
public:
    // read a text file
    TokenizedFile(const std::string& filename,
                  int first_line_num = 1);

    // virtual file from a string content
    TokenizedFile(const std::string& content,
                  const std::string& filename,
                  int first_line_num);

    const std::string& get_line(int index) const;
    int line_count() const {
        return static_cast<int>(text_lines_.size());
    }

    const TokenizedLine& get_tokenized_line(int index) const;
    int tokenized_line_count() const {
        return static_cast<int>(tok_lines_.size());
    }

    void clear();

    const std::string& filename() const {
        return filename_;
    }
    int first_line_num() const {
        return first_line_num_;
    }
    bool inc_line_nums() const {
        return inc_line_nums_;
    }

private:
    std::string filename_;              // Source file name
    int first_line_num_ = 1;            // Initial line number
    bool inc_line_nums_ = true;         // Whether to increment line numbers
    std::vector<std::string> text_lines_;   // input text lines
    std::vector<TokenizedLine> tok_lines_;  // All not-empty tokenized lines

    void split_lines(const char*& p);
    void tokenize(const std::string& content);
    void tokenize_line(int& line_index, TokenizedLine& output);
};


// macro tokens
enum class MacroTokenType {
    Identifier,
    Number,
    StringLiteral,
    Operator,
    Punctuator,
};

struct MacroToken {
    MacroTokenType type;
    std::string text;
};

// tokenize the macro body into a list of MacroToken
std::vector<MacroToken> tokenize_macro_body(const std::string& body);

// Scanning functions for null-terminated strings (C-style)
// Each function advances 'p' if successful, returns true and sets 'out'.
// If not successful, 'p' is unchanged and returns false.

// Scan one or more whitespace characters (space, tab, etc.)
// Advances 'p' past the whitespace, returns true if at least one was found, false otherwise.
bool scan_whitespace(const char*& p);
void skip_whitespace(const char*& p);

// Scan a C identifier: [_a-zA-Z][_a-zA-Z0-9]*
bool scan_identifier(const char*& p, std::string& out);

// Scan an assemnbler label:
// '@' identifier (local label, refers to previous non-local label)
// identifier '@' identifier (local label fully qualified)
bool scan_label(const char*& p, std::string& out);

// Scan an integer literal (decimal, hex with 0x/0X, binary with 0b/0B, octal with 0 prefix)
bool scan_integer(const char*& p, int& out);

// Scan a floating-point literal (C-style)
bool scan_float(const char*& p, double& out);

// Scan a string literal (C-style, double quotes, supports escapes)
bool scan_string_literal(const char*& p, std::string& out);
std::string unescape_string(const std::string& str);

// Scan an operator or punctuator (e.g., "+", "-", "==", "&&", etc.)
bool scan_operator(const char*& p, std::string& out);

class Lexer {
public:
    Lexer();
    void reset(const std::string& input);
    Token next_token();
};

