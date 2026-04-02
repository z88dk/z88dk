//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>

// Keyword flags
static const int IS_ASM_DIRECTIVE = 1 << 5;
static const int IS_OPCODE = 1 << 6;
static const int IS_REGISTER = 1 << 7;
static const int IS_SEGMENT_REGISTER = 1 << 8;
static const int IS_8BIT_REGISTER = 1 << 9;
static const int IS_X_REGISTER = 1 << 10;
static const int IS_FLAG = 1 << 11;

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
bool keyword_is_asm_directive(Keyword kw);
bool keyword_is_register(Keyword kw);
bool keyword_is_segment_register(Keyword kw);
bool keyword_is_8bit_register(Keyword kw);
bool keyword_is_x_register(Keyword kw);
bool keyword_is_flag(Keyword kw);
bool keyword_is_opcode(Keyword kw);
bool keyword_is_instruction(Keyword kw);
