//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <vector>
#include "lexer.h"
#include "preproc_context.h"

bool eval_const_expr(
    PreprocessorContext& ctx,
    const std::vector<Token>& expr_tokens,
    int& result);

