//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>

// Keyword flags
static const int IS_DIRECTIVE = 1 << 0;
static const int IS_NAME_DIRECTIVE = 1 << 1;
static const int IS_CONDITIONAL_DIRECTIVE = 1 << 2;
static const int IS_REGISTER = 1 << 3;
static const int IS_FLAG = 1 << 4;
static const int IS_OPCODE = 1 << 5;

#define X(id, text, flags) id,
enum class Keyword {
    None = 0,
#include "keywords.def"
};
#undef X

// Convert string to Keyword enum, returns Keyword::None if not found
Keyword keyword_lookup(const std::string& s);
std::string keyword_to_string(Keyword kw);

// Check if a keyword type
bool keyword_is_directive(Keyword kw);
bool keyword_is_name_directive(Keyword kw);
bool keyword_is_conditional_directive(Keyword kw);
bool keywrord_is_register(Keyword kw);
bool keyword_is_flag(Keyword kw);
bool keyword_is_opcode(Keyword kw);


