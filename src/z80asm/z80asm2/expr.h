//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer.h"

// Evaluate a C-style constant expression starting at p.
// Advances p to the first character after the parsed expression.
// Returns true on success and the evaluated integer
// return false and p unchanged on failure.
bool eval_const_expr(const TokensLine& line, unsigned& i, int& value);
