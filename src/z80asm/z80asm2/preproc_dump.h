//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <vector>
#include "lexer.h"
#include "preproc_directives.h"

void dump_after_directives(const std::vector<LogicalLine>& lines);
void dump_after_macroexpansion(const std::vector<Token>& tokens);
void dump_after_preprocess(const std::vector<Token>& tokens);
