//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer_keywords.h"
#include <string>

Keyword cpu_invert_flag_condition(Keyword kw);
void swap_ix_iy(std::string& inout_text, Keyword& inout_kw);

