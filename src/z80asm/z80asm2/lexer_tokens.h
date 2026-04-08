//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer_keywords.h"
#include "string_interner.h"
#include "source_loc.h"

enum class TokenType : uint8_t {
#define X(id, text) id,
#include "lexer_tokens.def"
};

struct Token {
    TokenType type = TokenType::EndOfLine;  // 1 byte
    Keyword keyword = Keyword::None;        // 2 bytes
    StringInterner::Id text_id = 0;         // 4 bytes

    union {                                 // 8 bytes
        int int_value;
        double float_value;
        StringInterner::Id str_value_id;
    } value;

    SourceLoc loc;                          // 8 bytes

    static Token token(TokenType type_, std::string_view text_,
                       const SourceLoc& loc);
    static Token identifier(std::string_view text_,
                            const SourceLoc& loc);
    static Token integer(std::string_view text_, int value,
                         const SourceLoc& loc);
    static Token floating(std::string_view text_, double value,
                          const SourceLoc& loc);
    static Token string(std::string_view text_, std::string_view value,
                        const SourceLoc& loc);
    static Token end_of_line(const SourceLoc& loc);
};

enum class LineOrigin {
    RawInput,          // from file stack
    MacroFeedback,     // from macro engine
    ReadyToAssemble    // already expanded, do NOT expand again
};

struct LogicalLine {
    SourceLoc loc;
    std::vector<Token> tokens;
    LineOrigin origin = LineOrigin::RawInput;

    LogicalLine() = default;
    LogicalLine(const SourceLoc& loc_,
        LineOrigin origin_ = LineOrigin::RawInput);
};
