//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "keywords.h"
#include "utils.h"
#include <algorithm>
#include <unordered_map>

#define X(id, text, flags) { text, Keyword::id },
Keyword keyword_lookup(const std::string& s) {
    static const std::unordered_map<std::string, Keyword> keyword_map = {
#include "keywords.def"
    };
    auto it = keyword_map.find(to_upper(s));
    return it != keyword_map.end() ? it->second : Keyword::None;
}
#undef X

#define X(id, text, flags) flags,
static const int keyword_flags[] = {
    0,
#include "keywords.def"
};
#undef X

#define X(id, text, flags) text,
std::string keyword_to_string(Keyword kw) {
    static const char* keyword_strings[] = {
        "None",
#include "keywords.def"
    };
    return keyword_strings[static_cast<int>(kw)];
}
#undef X

bool keyword_is_directive(Keyword kw) {
    int flags = keyword_flags[static_cast<int>(kw)];
    return (flags & IS_DIRECTIVE) != 0;
}

bool keyword_is_name_directive(Keyword kw) {
    int flags = keyword_flags[static_cast<int>(kw)];
    return (flags & IS_NAME_DIRECTIVE) != 0;
}

bool keyword_is_conditional_directive(Keyword kw) {
    int flags = keyword_flags[static_cast<int>(kw)];
    return (flags & IS_CONDITIONAL_DIRECTIVE) != 0;
}

bool keywrord_is_register(Keyword kw) {
    int flags = keyword_flags[static_cast<int>(kw)];
    return (flags & IS_REGISTER) != 0;
}

bool keyword_is_flag(Keyword kw) {
    int flags = keyword_flags[static_cast<int>(kw)];
    return (flags & IS_FLAG) != 0;
}

bool keyword_is_opcode(Keyword kw) {
    int flags = keyword_flags[static_cast<int>(kw)];
    return (flags & IS_OPCODE) != 0;
}

bool keyword_is_instruction(Keyword kw) {
    return keyword_is_directive(kw) ||
           keyword_is_name_directive(kw) ||
           keyword_is_conditional_directive(kw) ||
           keyword_is_opcode(kw);
}

