//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer.h"
#include <vector>

void apply_alt_registers(std::vector<Token>& tokens);
void apply_dot_directive_merge(std::vector<Token>& tokens);
