//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <vector>
#include "lexer_tokens.h"

// driver function
std::vector<LogicalLine> hla_process(const std::vector<LogicalLine>& lines);
