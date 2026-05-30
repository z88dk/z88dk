//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer_keywords.h"
#include "lexer_tokens.h"
#include "source_loc.h"
#include "string_interner.h"
#include <cstdint>
#include <string>
#include <string_view>
#include <vector>

enum class TokenType : uint8_t {
#define X(id, text) id,
#include "lexer_tokens.def"
};

std::string to_string(TokenType token_type);

struct Token {
    TokenType type = TokenType::EndOfLine;  // 1 byte
    Keyword keyword = Keyword::None;        // 2 bytes
    StringInterner::Id text_id = 0;         // 4 bytes

    union {                                 // 8 bytes
        int int_value;
        double float_value;
        StringInterner::Id str_value_id;
        size_t label_at_pos;                // position of '@' in text_id
    } value = {};

    SourceLoc loc;                          // 8 bytes

    static Token token(TokenType type_, std::string_view text,
                       const SourceLoc& loc);
    static Token identifier(std::string_view ident,
                            const SourceLoc& loc);
    static Token local_label(std::string_view ident, size_t at_pos,
                             const SourceLoc& loc);
    static Token integer(std::string_view text, int value,
                         const SourceLoc& loc);
    static Token floating(std::string_view text, double value,
                          const SourceLoc& loc);
    static Token string(std::string_view text, std::string_view value,
                        const SourceLoc& loc);
    static Token end_of_line(const SourceLoc& loc);
};

std::string to_string(Token token);
std::string to_string(const std::vector<Token>& tokens);

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

// reference to tokens being parsed, with current position and error reporting
struct ParseLine {
    const std::vector<Token>& tokens;
    size_t pos = 0;

    ParseLine(const std::vector<Token>& tokens_, size_t pos_ = 0);
    const Token& peek(size_t offset = 0) const;
    void advance();
    bool eof() const;
    void error(std::string_view message) const;
    bool check_end_of_line();
    std::string prev_token_text() const;
};
