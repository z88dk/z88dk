//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "ast.h"
#include "lexer.h"
#include <vector>

// simplify the AST by folding constant expressions
void simplify_exprs(Prog& prog);

// simplify the simpler language result of lowering the AST
void simplify_exprs(std::vector<Token>& tokens);
