//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
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

bool keyword_is_preproc_directive(Keyword kw) {
    int flags = keyword_flags[static_cast<int>(kw)];
    return (flags & IS_PREPROC_DIRECTIVE) != 0;
}

bool keyword_directive_has_file_arg(Keyword kw) {
    int flags = keyword_flags[static_cast<int>(kw)];
    return (flags & DIRECTIVE_HAS_FILE_ARG) != 0;
}

bool keyword_is_preproc_name_directive(Keyword kw) {
    int flags = keyword_flags[static_cast<int>(kw)];
    return (flags & IS_PREPROC_NAME_DIRECTIVE) != 0;
}

bool keyword_is_asm_directive(Keyword kw) {
    int flags = keyword_flags[static_cast<int>(kw)];
    return (flags & IS_ASM_DIRECTIVE) != 0;
}

bool keyword_is_conditional_directive(Keyword kw) {
    int flags = keyword_flags[static_cast<int>(kw)];
    return (flags & IS_CONDITIONAL_DIRECTIVE) != 0;
}

bool keyword_is_hla_directive(Keyword kw) {
    int flags = keyword_flags[static_cast<int>(kw)];
    return (flags & IS_HLA_DIRECTIVE) != 0;
}

bool keyword_is_register(Keyword kw) {
    int flags = keyword_flags[static_cast<int>(kw)];
    return (flags & IS_REGISTER) != 0;
}

bool keyword_is_segment_register(Keyword kw) {
    int flags = keyword_flags[static_cast<int>(kw)];
    return (flags & IS_SEGMENT_REGISTER) != 0;
}

bool keyword_is_8bit_register(Keyword kw) {
    int flags = keyword_flags[static_cast<int>(kw)];
    return (flags & IS_8BIT_REGISTER) != 0;
}

bool keyword_is_x_register(Keyword kw) {
    int flags = keyword_flags[static_cast<int>(kw)];
    return (flags & IS_X_REGISTER) != 0;
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
    return keyword_is_preproc_directive(kw) ||
           keyword_is_preproc_name_directive(kw) ||
           keyword_is_conditional_directive(kw) ||
           keyword_is_asm_directive(kw) ||
           keyword_is_opcode(kw);
}

