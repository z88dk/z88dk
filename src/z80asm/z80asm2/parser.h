//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "ast.h"
#include "lexer_tokens.h"
#include <memory>
#include <vector>

std::unique_ptr<LabelStmt> parse_label(ParseLine& pline);
std::unique_ptr<Program> parse(const std::vector<LogicalLine>& asm_lines);
