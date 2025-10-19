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

#define X(id, text, flags) id,
enum class Keyword {
    None = 0,
#include "keywords.def"
};
#undef X

// Convert string to Keyword enum, returns Keyword::None if not found
Keyword to_keyword(const std::string& s);
std::string keyword_to_string(Keyword kw);

// Check if a keyword type
bool keyword_is_directive(Keyword kw);
bool keyword_is_name_directive(Keyword kw);
bool keyword_is_conditional_directive(Keyword kw);

// Convert string to upper/lower case
std::string to_upper(const std::string& s);
std::string to_lower(const std::string& s);

// trim whitspace at the beginnint and at the end
std::string ltrim(const std::string& s);
std::string rtrim(const std::string& s);
std::string trim(const std::string& s);
