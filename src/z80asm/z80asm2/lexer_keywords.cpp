//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "lexer_keywords.h"
#include "release_assert.h"
#include "string_utils.h"
#include <string>
#include <string_view>
#include <unordered_map>

Keyword keyword_lookup(std::string_view s) {
    static const std::unordered_map<std::string, Keyword> keyword_map = {
#define X(id, text, flags) { text, Keyword::id },
#include "lexer_keywords.def"
    };
    auto it = keyword_map.find(to_upper(s));
    return it != keyword_map.end() ? it->second : Keyword::None;
}

std::string to_string(Keyword kw) {
    static const char* keyword_strings[] = {
#define X(id, text, flags) text,
#include "lexer_keywords.def"
    };
    return keyword_strings[static_cast<size_t>(kw)];
}

static const int keyword_flags[] = {
#define X(id, text, flags) flags,
#include "lexer_keywords.def"
};

bool keyword_directive_has_file_arg(Keyword kw) {
    if (kw == Keyword::INCLUDE ||
            kw == Keyword::BINARY ||
            kw == Keyword::INCBIN ||
            kw == Keyword::LINE ||
            kw == Keyword::C_LINE) {
        return true;
    }
    return false;
}

bool keyword_is_register(Keyword kw) {
    int flags = keyword_flags[static_cast<size_t>(kw)];
    return (flags & IS_REGISTER) != 0;
}

bool keyword_is_x_register(Keyword kw) {
    int flags = keyword_flags[static_cast<size_t>(kw)];
    return (flags & IS_X_REGISTER) != 0;
}

bool keyword_is_hla_djnz_register(Keyword kw) {
    int flags = keyword_flags[static_cast<size_t>(kw)];
    return (flags & IS_HLA_DJNZ_REGISTER) != 0;
}

bool keyword_is_flag(Keyword kw) {
    int flags = keyword_flags[static_cast<size_t>(kw)];
    return (flags & IS_FLAG) != 0;
}

