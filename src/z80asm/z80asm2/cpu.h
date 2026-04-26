//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer_keywords.h"
#include <string>
#include <string_view>
#include <vector>

enum class CPU {
#define X(code, id, name, defines)   id = code,
#include "cpu.def"
};

CPU cpu_lookup(std::string_view name);
std::string cpu_name(CPU cpu_id);
std::vector<std::string> cpu_names();
std::vector<std::string> cpu_all_defines();
std::vector<std::string> cpu_defines(CPU cpu_id);

Keyword cpu_invert_flag_condition(Keyword kw);
void swap_ix_iy(std::string& inout_text, Keyword& inout_kw);

