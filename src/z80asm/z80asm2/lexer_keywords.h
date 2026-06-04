//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
#include <cstdint>

// Keyword flags
static const int IS_REGISTER = 1 << 0;
static const int IS_X_REGISTER = 1 << 1;
static const int IS_HLA_DJNZ_REGISTER = 1 << 2;
static const int IS_FLAG = 1 << 3;

#define X(id, text, flags) id,
enum class Keyword : uint16_t {
#include "lexer_keywords.def"
};
#undef X

// Convert string to Keyword enum, returns Keyword::None if not found
Keyword keyword_lookup(std::string_view s);
std::string to_string(Keyword kw);

// Check if a keyword type
bool keyword_directive_has_file_arg(Keyword kw);
bool keyword_is_register(Keyword kw);
bool keyword_is_x_register(Keyword kw);
bool keyword_is_hla_djnz_register(Keyword kw);
bool keyword_is_flag(Keyword kw);

