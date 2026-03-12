//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>

// Keyword flags
static const int IS_PREPROC_DIRECTIVE = 1 << 0;
static const int DIRECTIVE_HAS_FILE_ARG = 1 << 1;
static const int IS_PREPROC_NAME_DIRECTIVE = 1 << 2;
static const int IS_CONDITIONAL_DIRECTIVE = 1 << 3;
static const int IS_HLA_DIRECTIVE = 1 << 4;
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
bool keyword_is_preproc_directive(Keyword kw);
bool keyword_directive_has_file_arg(Keyword kw);
bool keyword_is_preproc_name_directive(Keyword kw);
bool keyword_is_asm_directive(Keyword kw);
bool keyword_is_conditional_directive(Keyword kw);
bool keyword_is_hla_directive(Keyword kw);
bool keyword_is_register(Keyword kw);
bool keyword_is_segment_register(Keyword kw);
bool keyword_is_8bit_register(Keyword kw);
bool keyword_is_x_register(Keyword kw);
bool keyword_is_flag(Keyword kw);
bool keyword_is_opcode(Keyword kw);
bool keyword_is_instruction(Keyword kw);
