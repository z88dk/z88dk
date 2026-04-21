//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "lexer_keywords.h"
#include "string_utils.h"
#include <cassert>
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

std::string keyword_to_string(Keyword kw) {
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

bool keyword_is_preproc_directive(Keyword kw) {
    int flags = keyword_flags[static_cast<size_t>(kw)];
    return (flags & IS_PREPROC_DIRECTIVE) != 0;
}

bool keyword_directive_has_file_arg(Keyword kw) {
    int flags = keyword_flags[static_cast<size_t>(kw)];
    return (flags & DIRECTIVE_HAS_FILE_ARG) != 0;
}

bool keyword_is_preproc_name_directive(Keyword kw) {
    int flags = keyword_flags[static_cast<size_t>(kw)];
    return (flags & IS_PREPROC_NAME_DIRECTIVE) != 0;
}

bool keyword_is_asm_directive(Keyword kw) {
    int flags = keyword_flags[static_cast<size_t>(kw)];
    return (flags & IS_ASM_DIRECTIVE) != 0;
}

bool keyword_is_conditional_directive(Keyword kw) {
    int flags = keyword_flags[static_cast<size_t>(kw)];
    return (flags & IS_CONDITIONAL_DIRECTIVE) != 0;
}

bool keyword_is_hla_directive(Keyword kw) {
    int flags = keyword_flags[static_cast<size_t>(kw)];
    return (flags & IS_HLA_DIRECTIVE) != 0;
}

bool keyword_is_register(Keyword kw) {
    int flags = keyword_flags[static_cast<size_t>(kw)];
    return (flags & IS_REGISTER) != 0;
}

bool keyword_is_segment_register(Keyword kw) {
    int flags = keyword_flags[static_cast<size_t>(kw)];
    return (flags & IS_SEGMENT_REGISTER) != 0;
}

bool keyword_is_8bit_register(Keyword kw) {
    int flags = keyword_flags[static_cast<size_t>(kw)];
    return (flags & IS_8BIT_REGISTER) != 0;
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

bool keyword_is_opcode(Keyword kw) {
    int flags = keyword_flags[static_cast<size_t>(kw)];
    return (flags & IS_OPCODE) != 0;
}

bool keyword_is_instruction(Keyword kw) {
    return keyword_is_preproc_directive(kw) ||
           keyword_is_preproc_name_directive(kw) ||
           keyword_is_conditional_directive(kw) ||
           keyword_is_asm_directive(kw) ||
           keyword_is_opcode(kw);
}

Keyword keyword_invert_flag_condition(Keyword kw) {
    switch (kw) {
    case Keyword::C:
        return Keyword::NC;
    case Keyword::EQ:
        return Keyword::NE;
    case Keyword::GE:
        return Keyword::LT;
    case Keyword::GEU:
        return Keyword::LTU;
    case Keyword::GT:
        return Keyword::LE;
    case Keyword::GTU:
        return Keyword::LEU;
    case Keyword::K:
        return Keyword::NK;
    case Keyword::LE:
        return Keyword::GT;
    case Keyword::LEU:
        return Keyword::GTU;
    case Keyword::LO:
        return Keyword::LZ;
    case Keyword::LT:
        return Keyword::GE;
    case Keyword::LTU:
        return Keyword::GEU;
    case Keyword::LZ:
        return Keyword::LO;
    case Keyword::M:
        return Keyword::P;
    case Keyword::NC:
        return Keyword::C;
    case Keyword::NE:
        return Keyword::EQ;
    case Keyword::NK:
        return Keyword::K;
    case Keyword::NV:
        return Keyword::V;
    case Keyword::NX5:
        return Keyword::X5;
    case Keyword::NZ:
        return Keyword::Z;
    case Keyword::P:
        return Keyword::M;
    case Keyword::PE:
        return Keyword::PO;
    case Keyword::PO:
        return Keyword::PE;
    case Keyword::V:
        return Keyword::NV;
    case Keyword::X5:
        return Keyword::NX5;
    case Keyword::Z:
        return Keyword::NZ;
    default:
        assert(0);
        return Keyword::None;
    }
}

