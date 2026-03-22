//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer.h"
#include "source_loc.h"
#include "utils.h"
#include <cstdint>
#include <string>
#include <vector>

struct TokenizeState {
    bool in_multiline_comment = false;
    SourceLoc multiline_comment_start;
};

struct MergedLine {
    StringInterner::Id file_id = 0;
    uint32_t logical_line = 0;      // logical line number (after merging continuations)
    std::string text;               // the merged characters
    std::vector<SourceLoc> locmap;  // same length as text
};

// identifier character: letter, digit, or underscore
inline bool is_ident_start(char c) {
    return is_alpha(c) || c == '_';
}

inline bool is_ident_char(char c) {
    return is_alpha(c) || is_dec_digit(c) || c == '_';
}

void tokenize_line(const MergedLine& line,
                   TokenizeState& state,
                   std::vector<Token>& out);
