//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "keywords.h"
#include "source_loc.h"
#include "utils.h"
#include <string.h>

// all strings stored in strpool for memory efficiency and fast comparisons

enum class TokenType {
    // Literals
    Identifier,
    Integer,
    Float,
    String,

    // Operators
    Plus,           // +
    Minus,          // -
    Multiply,       // *
    Divide,         // /
    Modulo,         // %
    Power,          // **

    BitwiseAnd,     // &
    BitwiseOr,      // |
    BitwiseXor,     // ^
    BitwiseNot,     // ~
    LeftShift,      // <<
    RightShift,     // >>

    LogicalAnd,     // &&
    LogicalOr,      // ||
    LogicalXor,     // ^^
    LogicalNot,     // !

    EQ,             // =
    NE,             // !=
    LT,             // <
    LE,             // <=
    GT,             // >
    GE,             // >=

    // Delimiters
    LeftParen,      // (
    RightParen,     // )
    LeftBracket,    // [
    RightBracket,   // ]
    LeftBrace,      // {
    RightBrace,     // }
    Comma,          // ,
    Colon,          // :
    Dot,            // .
    Question,       // ?
    Hash,           // #
    DoubleHash,     // ##
    At,             // @
    Dollar,         // $
    Backslash,      // (backslash)

    // Assembly instruction pointer
    ASMPC,

    // disambiguate +register from +expression
    PlusA,          // +A
    PlusBC,         // +BC
    PlusDE,         // +DE
    PlusHL,         // +HL
    PlusIX,         // +IX
    PlusIY,         // +IY

    EndOfLine,
    EndOfFile,
};

struct Token {
    TokenType type = TokenType::EndOfFile;
    Keyword keyword = Keyword::None;
    const char* text = "";
    int int_value = 0;
    double float_value = 0.0;
    const char* str_value = "";
    SourceLoc loc;

    static Token token(TokenType type_, const std::string& text_,
                       const SourceLoc& loc);
    static Token identifier(const std::string& text_,
                            const SourceLoc& loc);
    static Token integer(const std::string& text_, int value,
                         const SourceLoc& loc);
    static Token floating(const std::string& text_, double value,
                          const SourceLoc& loc);
    static Token string(const std::string& text_, const std::string& value,
                        const SourceLoc& loc);
    static Token end_of_line(const SourceLoc& loc);
    static Token end_of_file(const SourceLoc& loc);
};
